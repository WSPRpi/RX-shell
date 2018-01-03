import time
import subprocess
import threading
import sys

#####################
#Configuration stuff#
#####################
callsign = 'm0wut'
locator = 'io93fp'
freq = '14.0956' #in MHz

def start_wspr_rx():
	subprocess.call(['./wspr-rx', callsign, locator, freq])


if __name__ == "__main__":
	print("WSPR Decoder Test Program, M0WUT and M0IKY")
	print("Callsign: {}, Locator: {}, Frequency(MHz): {}\r\n".format(callsign,locator,freq))
	while (1):
		current_time = time.gmtime()
		if(current_time.tm_min % 2 == 0 and current_time.tm_sec == 0):
			print("Starting WSPR decode at {:02d}:{:02d}\n".format(current_time.tm_hour, current_time.tm_min))
			try:
				t=threading.Thread(target = start_wspr_rx, args=())
				t.start()
			except:
				sys.exit(1)

			time.sleep(1)
		if threading.active_count() > 3:
			#Something has gone wrong
			print("Oh crap, {} threads active".format(threading.active_count()))
			sys.exit(1)
