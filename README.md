# Shell-based decoder for WSPR
Simple shell script which Records 114 seconds of audio, then passes it to wsprd decoding software.

Requisites:
* libfftw3-3 (apt install libfftw3-dev)
* arecord (apt install alsa-utils)
* sox (apt install sox)
* wsprd (executable installed with wsjtx) install full WSJTX onto Pi, copy the wsprd file, reflash OS and transferred the executable back

All binaries (arecord, sox, wsprd) must be on the `$PATH` for this script to work.
ALL_WSPR.TXT is example output.
