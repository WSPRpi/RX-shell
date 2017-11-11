#!/bin/bash
##Assorted insanity by M0WUT to make a better WSPR decoder

buffer_num="0"
old_buffer="1"
first="0"


if [[ "$#" != 3 ]]
then
	echo "Usage is of the format ./wspr_rx.sh callsign locator frequency(in MHz)"
	echo "Example: \"./wspr_rx.sh m0wut jo02af 14.0956 \""
	exit 1
fi
echo "WSPR Decoder by M0WUT: Callsign = $1, Locator = $2, Frequency = $3"

	minute=$(date +"%-M")
	second=$(date +"%-S")
sudo arecord -f S16_LE -r 48000 --duration=114 -q -t wav -D hw:0,0 -c 2 /mnt/ramdisk/test_"$buffer_num".wav 
echo "Recording complete"
sox /mnt/ramdisk/test_"$buffer_num".wav -c 1 -r 12000 output.wav
echo "Decimation complete"
~/wspr_rx/wsprd -wf "$3" output.wav >/dev/null 2>&1
sed -i 's/tput   //g' ALL_WSPR.TXT
sed -i "s/^....../$(date +%y%m%d) $report_time/g" ALL_WSPR.TXT
echo ""
echo ""
cat ALL_WSPR.TXT
echo ""
echo ""
#curl -F allmept=@ALL_WSPR.TXT -F call="$1" -F grid="$2" wsprnet.org/meptspots.php >/dev/null 2>&1
echo "Upload complete"
rm ALL_WSPR.TXT


