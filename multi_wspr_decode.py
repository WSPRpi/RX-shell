import numpy as np
import soundfile as sf
from math import floor as floor
from threading import Thread
import threading
import time


def channel_calculate(channel, channel_spacing, fft_length, nyquist_frequency, left_fft, right_fft, filename, sampling_frequency):
	print("Starting decode of channel {}".format(channel))
	bottom = floor(channel * channel_spacing * fft_length / nyquist_frequency) 
	top = floor((channel+1) * channel_spacing * fft_length / nyquist_frequency) 
	
	zero_pad_amount = fft_length-(top - bottom)
	split_left_fft = np.append(left_fft[bottom:top],([0]*zero_pad_amount))
	split_right_fft = np.append(right_fft[bottom:top], ([0]*zero_pad_amount))

	split_left_audio = np.fft.irfft(split_left_fft)
	split_right_audio = np.fft.irfft(split_right_fft)

	new_wav = np.column_stack((split_left_audio, split_right_audio))
	results_filename = "{}_{}.wav".format(filename[:-4], channel)
	sf.write(results_filename, new_wav, sampling_frequency)

def wspr_split(filename, instances):
	
	MAX_THREADS = 2
	 
	channel_spacing = 5000 #channel spacing in Hz
	
	data, sampling_frequency = sf.read(filename)
	

	nyquist_frequency = sampling_frequency / 2
	
	if(nyquist_frequency / channel_spacing) < instances:
		raise Exception("Cannot fit {} channels of {}Hz into bandwidth of {}Hz (sample rate / 2)".format(instances, channel_spacing,nyquist_frequency))
	left_data = data[:,0]
	right_data = data[:,1]
	
	print("{} Sampling rate: {}, No of datapoints: {}".format(filename, sampling_frequency, len(left_data)))
	
	print("Performing FFT")
	left_fft = np.fft.rfft(left_data)
	right_fft = np.fft.rfft(right_data)
	
	fft_length = len(left_fft)

	results = [0] * instances
	

	print("Splitting FFT")
	for channel in range (0, instances):
		while(threading.active_count() > MAX_THREADS):
			pass
		t = Thread(target = channel_calculate, args=(channel, channel_spacing, fft_length, nyquist_frequency, left_fft, right_fft, filename, sampling_frequency))
		t.start()
		#results[channel]=(new_wav)
		
	while threading.active_count() > 1:
		pass
	
		
	
	
	

		
	print("Done")
	

		
		
if __name__ == '__main__':
	start = time.time()
	wspr_split("big_file.wav", 4)
	end = time.time()
	print("Time to process big file: {}\n\n".format(end-start))
	
	start = time.time()
	wspr_split("small_file.wav", 4)
	end = time.time()
	print("Time to process small file: {}".format(end-start))