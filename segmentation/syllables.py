
import numpy as np


def find_syllables(spectogram, time_array, db_diff ):
    
    # get the maximum per time bin (log-magnitude)
    max_db_array = np.max(20*np.log10(spectogram),axis=0)
    # get the time position and value of spectogram maximum
    max_index = np.argmax(max_db_array)
    max_value = max_db_array[max_index]
    # min value of maxima to be considered a syllabe
    min_syllabe = max_value - db_diff

    interval_list = [] # empty list to hold syllabe intervals

    # until maximum is larger than min por syllabe
    while(max_db_array.max() > min_syllabe):
    
        # get maximum position and value
        max_index = np.argmax(max_db_array)
        max_value = max_db_array[max_index]

        interval = [0 ,len(max_db_array)-1] # init interval at edges

        # iterate from maxima to the left
        for i in xrange(max_index, 0, -1):
            # if maximum in bin smaller than cutoff
            if (max_db_array[i] < (max_value - db_diff)):
                # interval edge is current position and break loop
                interval[0] = i
                break

        # iterate from maxima to the right
        for i in xrange(max_index, len(max_db_array)):
            # if maximum in bin smaller than cutoff
            if (max_db_array[i] < (max_value - db_diff)):
               # interval edge is current position and break loop
               interval[1] = i
               break
    
        # add current interval to list 
        interval_list.append(interval)
        # set interval to zero (so next can be searched)
        max_db_array[interval[0]:interval[1]+1] = 0
   
    # change from bin indexes to time 
    syllables = time_array[np.array(interval_list)]

    return syllables 


def join_in_segments(syllables, max_silence):
    
    # sort syllabe edges in ascending order
    sort_init = np.sort(syllables[:, 0])
    sort_end  = np.sort(syllables[:, 1])

    # boolean array (true if silences larger tha max silence)
    is_long_silence = (sort_init[1:]-sort_end[:-1]) > max_silence

    # concate with leftmost init and rightmost end
    seg_inits = np.concatenate(( sort_init[:1], sort_init[1:][is_long_silence]))
    seg_ends = np.concatenate((sort_end[:-1][is_long_silence],  sort_end[-1:]))
 
    # stack init and ends together and transpose
    segments = np.transpose(np.vstack((seg_inits, seg_ends)))

    return segments
    
