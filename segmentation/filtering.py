
import scipy.signal as sig
import numpy as np

def highpass_filter(wav_data, sample_rate, crit_freq = 1000 ):
    
    N = 10                            # order of the filter
    nyq_freq = float(sample_rate)/2.  # nyquist frequency
    crit_freq_norm = crit_freq/nyq_freq    # critical frequency (normalized)
    rp = 1                            # passband ripple (dB)
    rs = 80                           # stopband min attenuation (dB)
    btype = 'highpass'
    ftype = 'ellip'
    b, a = sig.iirfilter(N, crit_freq_norm, rp, rs, btype, ftype)

    # apply filter and return filtered data 
    return  sig.lfilter(b, a, wav_data)


def find_fundamental_freq(wav_data, sample_rate ):
    
    nyq_freq = float(sample_rate)/2.  # nyquist frequency
    # compute fft ( next pow of 2 for perfomance)
    nfft =  int(2**np.ceil(np.log2(len(wav_data))))
    # only get magnitude and first half
    fft_spectrum = np.abs(np.fft.fft(wav_data,nfft)[0:nfft/2])
    # properly scale energy
    fft_spectrum[1:len(fft_spectrum)-1] = 2*fft_spectrum[1:len(fft_spectrum)-1] 

 
    max_freq_index = fft_spectrum.argmax() # get max index
    # transform frecuency to Hz
    fund_freq = max_freq_index*nyq_freq/len(fft_spectrum)
    
    return fund_freq
    

def fundamental_freq_filter( wav_data, sample_rate, f0_ratio = 0.6 ):
    
    # get fundamental frequency
    fund_freq =  find_fundamental_freq (wav_data, sample_rate )
    # apply high pass filter with crit freq f0_ratio*fund_freq
    return highpass_filter(wav_data, sample_rate, f0_ratio*fund_freq)
 
 
def filter_chain( wav_data, sample_rate, crit_freq = 1000, f0_ratio = 0.6):
    
    # apply basic highpass filter
    filtered_data = highpass_filter(wav_data, sample_rate, crit_freq)
    # apply dynamic highpass fiter
    filtered_data = fundamental_freq_filter(filtered_data, sample_rate, f0_ratio)
    
    return filtered_data
    
