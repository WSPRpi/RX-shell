#!/bin/bash
##Assorted insanity by M0WUT to make a better WSPR decoder

buffer_num="0"
old_buffer="1"
first="0"


if [[ "$#" != 2 ]]
then
	echo "Usage is of the format ./wspr_rx.sh callsign locator "
	echo "Example: \"./wspr_rx.sh m0wut jo02af \""
	exit 1
fi
echo "WSPR Decoder by M0WUT: Callsign = ""$1"", Locator = ""$2"
echo $(date +"%H-%M-%S")"  Started, waiting for even minute"
while true
do
	minute=$(date +"%-M")
	second=$(date +"%-S")
	if (( $second == 0 )) && (( (($minute % 2)) == 0 ))
	then
		sudo arecord -f S16_LE -r 96000 --duration=118 -q -t wav -D hw:0,0 -c 2 /mnt/ramdisk/test_"$buffer_num".wav &
		record_pid=$!
		if [[ "$first" != "0" ]]
		then
			echo $(date +"%H-%M-%S")"  Recording into buffer ""$buffer_num"", starting decode of buffer ""$old_buffer"
			while kill -0 $decode_pid >/dev/null 2>&1
			do
				:
			done
			echo $(date +"%H-%M-%S")"  Decode of buffer ""$old_buffer"" finished, uploading spots"
			awk '{$6=sprintf("%.7f",$6+14.0956); print}' ALL_WSPR.TXT >> /mnt/ramdisk/temp.txt && rm ALL_WSPR.TXT && mv /mnt/ramdisk/temp.txt ALL_WSPR.TXT
			#curl -F allmept=@ALL_WSPR.TXT -F call="$1" -F grid="$2" wsprnet.org/meptspots.php
		else
			echo $(date +"%H-%M-%S")"  Recording into buffer ""$buffer_num"", no buffer to decode"
			first="1"
		fi
		wait $record_pid
		echo $(date +"%H-%M-%S")"  Finished recording into buffer ""$buffer_num"
		~/wspr_rx/wsprd /mnt/ramdisk/test_"$buffer_num".wav >/dev/null &
		decode_pid=$!
		if [ "$buffer_num" == "0" ]
		then
			buffer_num="1"
			old_buffer="0"
		else
			buffer_num="0"
			old_buffer="1"
		fi
	fi
done
