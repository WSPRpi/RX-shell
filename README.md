Shell based decoder for WSPR

Requisites:
*libfftw3-3 (apt install libfftw3-dev)
*sox (apt install sox)
*wsprd (executable installed with wsjtx) I installed full WSJTX onto Pi, copied the wsprd file, reflashed OS and transferred the executable back
*100MB RAM mounted in /mnt/ramdisk (prevents lots of writing to SD card)

Simple shell script which Records 114 seconds of audio, then passes it to wsprd decoding software

ALL_WSPR.TXT is example output





