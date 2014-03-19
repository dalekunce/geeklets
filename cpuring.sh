file://localhost/tmp/cpu-ring.png

theme=`cat ~/Documents/CIRCLE/CONFIG | grep 'CPU_THEME' | tail -n1 | awk '{print $2}'`


if [ -f ~/Documents/CIRCLE/CPU/$theme/cpu-meter.sh ]
then
	sh ~/Documents/CIRCLE/CPU/$theme/cpu-meter.sh
else
	sh ~/Documents/CIRCLE/CPU/White/cpu-meter.sh
fi
