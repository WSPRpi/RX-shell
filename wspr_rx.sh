#!/bin/sh
#Assorted insanity by M0WUT to make a better WSPR decoder

if [[ "$#" != 3 ]]
then
	echo "Usage is of the format ./wspr_rx.sh callsign locator frequency(in MHz)"
	echo "Example: \"./wspr_rx.sh m0wut jo02af 14.0956 \""
	exit 1
fi
echo "WSPR Decoder by M0WUT: Callsign = $1, Locator = $2, Frequency = $3"

cd /tmp
start_time=$(date +"%y%m%d %H%M")

echo "Recording..."
arecord -f S16_LE -r 48000 --duration=114 -q -t wav -D hw:0,0 -c 2 | sox -t wav -c 1 -r 12000 - - | wsprd -wf "$3" /dev/stdin >/dev/null 2>&1
echo "...done."

echo ""
echo ""
sed -i "s/tput   //g;s/^....../$start_time/g" < ALL_WSPR.TXT
echo ""
echo ""

echo "Uploading..."
curl -F allmept=@ALL_WSPR.TXT -F call="$1" -F grid="$2" wsprnet.org/meptspots.php >/dev/null 2>&1
echo "...done."
rm ALL_WSPR.TXT
