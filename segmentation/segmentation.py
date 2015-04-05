
import matplotlib.pyplot as plt
import numpy as np

from filtering import filter_chain
from syllables import find_syllables, join_in_segments

def simple_segmentation( wav_data, sample_rate, db_diff = 17, max_silence = 0.8 ): 

    # filter data
    filtered_data = filter_chain(wav_data, sample_rate, 1000, 0.6)

    # create figure and axis
    f, ax = plt.subplots()

    # get spectograma nd spectogram plot (i.e. STFT)
    NFFT = 1024
    noverlap = 256
    window = np.kaiser(NFFT, 8)
    spectogram, freqs, time_array, im = ax.specgram(filtered_data, NFFT=NFFT,
                                                    Fs=sample_rate, noverlap=noverlap,
                                                    window=window, cmap = 'Greys')
    ax.set_xlim(0, len(wav_data)/float(sample_rate)) # remove empty plot region
    ax.set_ylim(0, sample_rate/2.)                   # remove empty plot region

    syllables = find_syllables(spectogram, time_array, db_diff)

    segments = join_in_segments(syllables, max_silence) 

    # add segments to plot as red shadowed areas
    hspans = []
    for segment in segments:
        hspans.append(ax.axvspan(segment[0], segment[1], facecolor='r', alpha = 0.2))
    
    return segments, f, ax

    



