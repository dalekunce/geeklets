if [ `which composite | grep -c "composite"` != 0 ]
then
composite=`which composite`
else
composite=`cat ~/Documents/CIRCLE/CONFIG | grep 'COMPOSITE_PATH' | tail -n1 | awk '{print $2}'`;
fi
if [ `which convert | grep -c "convert"` != 0 ]
then
covert=`which covert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
theme=`cat ~/Documents/CIRCLE/CONFIG | grep 'ITUNES_THEME' | tail -n1 | awk '{print $2}'`
itnsps=`osascript -e "tell application \"System Events\"" -e "if (exists application process \"iTunes\") then" -e "return \"yes\"" -e "else" -e "return \"no\"" -e "end if" -e "end tell"`
lasttrack=`tail /tmp/itunestrack`
out=`echo /tmp/iTunes-stat-c.png`
tcover=`echo /tmp/iTunes-Cover-c.png`
cover=`echo ~/Documents/CIRCLE/ITUNES/iTunes-Cover.png`

if [ "$itnsps" = "yes" ] 
then 
itnsplst=`osascript -e "tell application \"iTunes\"" -e "return (get player state as string)" -e "end tell"`

		if [ "$itnsplst" = "playing" ] 
		then
			track=`osascript -e "tell application \"iTunes\"" -e "set curTrack to current track" -e "name of curTrack as string" -e "end tell"`
			album=`osascript -e "tell application \"iTunes\"" -e "set curTrack to current track" -e "album of curTrack as string" -e "end tell"`
			artist=`osascript -e "tell application \"iTunes\"" -e "set curTrack to current track" -e "artist of curTrack as string" -e "end tell"`
			itnesstat=`osascript -e "tell application \"iTunes\"" -e "set trackname to name of current track" -e "set trackduration to duration of current track" -e "set trackposition to player position" -e "set elapsed to round (trackposition / trackduration * 100)" -e "set output to elapsed" -e "end tell"`
			if [ "$track" != "" ]
				then
				echo "    \033[1;37m${track}\033[0m\c"
				printf "\n"
					if [ "$album" != "" ]
					then
						echo "    \033[1;37m${album}\033[0m\c"
						printf "\n"
					else 
					echo "    \033[1;37mUNKNOW\033[0m\c"
					printf "\n"
					fi
					if [  "$artist" != "" ]
					then
						echo "    \033[1;37m${artist}\033[0m\c"
						printf " "
					else 
						echo "    \033[1;37mUNKNOW\033[0m\c"
						printf " "
					fi
				fi
			playtrack=`echo $track-$artist-$album-$theme`;
			if [ "$lasttrack" != "$playtrack" ]
			then
				echo $track-$artist-$album-$theme > /tmp/itunestrack
				osascript -e "set myPath to ((path to home folder) as text) & \"Documents:\" & \"CIRCLE:\" & \"ITUNES:\"" -e "set artworkItunes to POSIX path of myPath & \"iTunes-Cover.png\"" -e "set defaultPic to POSIX path of myPath & \"default.png\"" -e "tell application \"iTunes\"" -e "set artData to data of artwork 1 of current track" -e "set fileRef to (open for access artworkItunes with write permission)" -e "try" -e "write artData to fileRef starting at 0" -e "close access fileRef" -e "on error" -e "try" -e "close access fileRef" -e "end try" -e "error" -e "end try" -e "end tell"
				if [ -f $cover ]
				then
					mv $cover $tcover
 									else 
 					cp -r ~/Documents/CIRCLE/ITUNES/$theme/default.png $tcover
				fi
					h=`sips --getProperty pixelHeight $tcover | tail -n1 | awk '{print $2}'`
					x=`sips --getProperty pixelWidth $tcover | tail -n1 | awk '{print $2}'`
					if [ $h -gt $x ]
					then
					ix="${x}"
					elif [ $h -lt $x ]
					then
						ix="${h}"
					elif [ $x -eq $h ]
					then
						ix="${h}"
					fi
					$convert $tcover -gravity Top -crop ${ix}x${ix}+0+0 +repage $tcover
					$convert $tcover -resize 200x $tcover 
					$convert -size 200x200 xc:none -fill $tcover  -draw "circle 100,100 100,1" $tcover 
			fi
			p=`echo $itnesstat`
			z=`echo "3.6 * ${p}" | bc`;y=`echo "-90 + $z" | bc`;
			if [ "$p" = "100" ]
			then
				$convert -size 700x300 xc:transparent -stroke White -strokewidth 15 -fill none -draw "arc 230,260 10,40 0,360"  $out
				$composite -geometry -230 -gravity center $tcover $out $out
			elif [ "$p" = "0" ]
			then
				$convert -size 1x1 xc:transparent $out
			else
				$convert -size 700x300 xc:transparent -stroke White -strokewidth 15 -fill none -draw "arc 230,260 10,40 -90,${y}"  $out
				$composite -geometry -230 -gravity center $tcover $out $out
			fi
			
		else
			if [ "$lasttrack" != "" ]
			then
				$convert -size 1x1 xc:transparent $out
				echo "" > /tmp/itunestrack
			fi
		fi
		
else
	if [ "$lasttrack" != "" ]
	then
		$convert -size 1x1 xc:transparent $out
		echo "" > /tmp/itunestrack
	fi
fi
