import time  
import subprocess
import threading
import sys

def start_wspr_rx():
	subprocess.call(['./wspr-rx', 'm0wut', 'io93fp', '14.0956'])


if __name__ == "__main__":
	print("WSPR Decoder, M0WUT")
	while (1):
		current_time = time.gmtime()
		if(current_time.tm_min % 2 == 0 and current_time.tm_sec == 0):
			print("Starting WSPR decode at {}:{}:{}".format(current_time.tm_hour, current_time.tm_min, current_time.tm_sec))
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
