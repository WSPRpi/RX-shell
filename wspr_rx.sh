#!/bin/bash
##Assorted insanity by M0WUT to be a better WSPR decoder

buffer_num="0"
while true
do
	minute=$(date +"%M")
	second=$(date +"%S")
	if [[ "$second" == "00" && $((minute % 2)) == 0 ]]
	then
		echo $(date +"%H-%M-%S")"  Recording"
		sudo arecord -f S16_LE -r 96000 --duration=118 -q -t wav -D hw:0,0 -c 2 /mnt/ramdisk/test_"$buffer_num".wav
		record_pid=$!
		wait $record_pid
		echo $(date +"%H-%M-%S")"  Recording Complete into buffer ""$buffer_num"
		~/wsprd /mnt/ramdisk/test_"$buffer_num".wav &
		decode_pid=$!
		if [ "$buffer_num" == "0" ]
		then
			buffer_num="1"
		else
			buffer_num="0"
		fi
		echo "Switched to buffer ""$buffer_num"
	fi
done
