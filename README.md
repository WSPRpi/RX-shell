Shell based decoder for WSPR

Requisites:
libfftw3-3
wsprd (executable installed with wsjtx) I installed full WSJTX onto Pi, copied the wsprd file, reflashed OS and transferred the executable back
100MB RAM mounted in /mnt/ramdisk (prevents lots of writing to SD card)

Simple shell script which Records 118 seconds of audio, then passes it to wsprd decoding software
This is then scraped by the scraper software written by M0IKY (Michael Rawson on github) for further processing

TODO: Add upload feature and a way to correct the frequency (currently only gives AF frequency so need to add RF offset)



