# Shell-based decoder for WSPR
Simple shell script which Records 114 seconds of audio, then passes it to wsprd decoding software.

Requisites:
* libfftw3-3: apt install libfftw3-dev
* arecord: should be already installed, if not apt install alsa-utils
* sox: apt install sox
* wsprd: git clone [https://github.com/WSPRpi/WSPR-Decoder.git](https://github.com/WSPRpi/WSPR-Decoder.git), make, copy output executable to path

sample.TXT is example output.
