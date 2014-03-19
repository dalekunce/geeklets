file://localhost/tmp/batt-ring.png

theme=`cat ~/Documents/CIRCLE/CONFIG | grep 'BATT_THEME' | tail -n1 | awk '{print $2}'`


if [ -f ~/Documents/CIRCLE/BATT/$theme/batt-meter.sh ]
then
	sh ~/Documents/CIRCLE/BATT/$theme/batt-meter.sh
else
	sh ~/Documents/CIRCLE/BATT/White/batt-meter.sh
fi
