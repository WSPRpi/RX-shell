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
echo $(date +"%H-%M-%S")"  Started, waiting for even minute"

while true
do
	minute=$(date +"%-M")
	second=$(date +"%-S")
	if (( $second == 0 )) && (( (($minute % 2)) == 0 ))
	then
		sudo arecord -f S16_LE -r 48000 --duration=114 -q -t wav -D hw:0,0 -c 2 /mnt/ramdisk/test_"$buffer_num".wav &
		record_pid=$!
		if [ "$buffer_num" == "0" ]
		then
			buffer0_start=$(date +"%H%M")
		else
			buffer1_start=$(date +"%H%M")
		fi

		if [[ "$first" != "0" ]]
		then
			echo $(date +"%H-%M-%S")"  Recording into buffer ""$buffer_num"", starting decimation of buffer ""$old_buffer"
			while kill -0 $decimate_pid >/dev/null 2>&1
			do
				:
			done
			echo $(date +"%H-%M-%S")"  Decimation of buffer ""$old_buffer"" complete, beginning decode"
			~/wspr_rx/wsprd -wf "$3" output.wav >/dev/null 2>&1 &
			decode_pid=$!
			while kill -0 $decode_pid >/dev/null 2>&1
			do
				:
			done
			echo $(date +"%H-%M-%S")"  Decode of buffer ""$old_buffer"" finished, uploading spots" 
			sed -i 's/tput   //g' ALL_WSPR.TXT
			if [ "$old_buffer" == "0" ]
			then
				report_time=$buffer0_start
			else
				report_time=$buffer1_start
			fi
			sed -i "s/^....../$(date +%y%m%d) $report_time/g" ALL_WSPR.TXT
			echo ""
			echo ""
			cat ALL_WSPR.TXT
			echo ""
			echo ""
			curl -F allmept=@ALL_WSPR.TXT -F call="$1" -F grid="$2" wsprnet.org/meptspots.php >/dev/null 2>&1
			rm ALL_WSPR.TXT
			echo $(date +"%H-%M-%S")"  Upload complete"
		else
			echo $(date +"%H-%M-%S")"  Recording into buffer ""$buffer_num"", no buffer to decode"
			first="1"
		fi
		wait $record_pid
		echo $(date +"%H-%M-%S")"  Finished recording into buffer ""$buffer_num"
		sox /mnt/ramdisk/test_"$buffer_num".wav -c 1 -r 12000 output.wav &
		decimate_pid=$!
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
