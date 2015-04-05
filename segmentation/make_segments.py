#! /bin/python2

import glob
import os.path
import xml.etree.ElementTree as ET
import numpy as np
from scipy.io import wavfile
from scipy.signal import decimate

from segmentation import simple_segmentation


# list with all wav files in date directory (i.e. examples)
example_paths = glob.glob("../data/LIFECLEF2014_BIRDAMAZON_XC_WAV_RN*.wav")

def process_wav_files(wav_file_paths = example_paths , output_dir = "", savefig = False):

    for wav_file_path in wav_file_paths:

        # import data and down sample
        raw_sample_rate, raw_wav_data = wavfile.read( wav_file_path )
        downsample_factor = 4
        wav_data = decimate(raw_wav_data, downsample_factor)
        sample_rate = raw_sample_rate/downsample_factor

        # segment data (obtain segments and figure)
        segments, f, ax = simple_segmentation(wav_data, sample_rate)

        # read attributes from xml
        mediaID, classID = xml_attributes(wav_file_path.replace('.wav','.xml'))
 
        # add title and labels to plot
        ax.set_title(" MediaID: {0} ClassID: {1} ".format(mediaID, classID))
        ax.set_xlabel("Time (seconds)")
        ax.set_ylabel("Frequency (Hz)")

        basename = os.path.basename(wav_file_path.replace('.wav',''))

        if savefig:
            # save figure to output dir
            f.savefig(os.path.join(output_dir, basename+".pdf"))
        
        # save segments to csv
        np.savetxt(os.path.join(output_dir, basename+".csv"),
                   segments, delimiter = ",", fmt = '%3.4f')

    return None
        


def xml_attributes(xml_file_path):

    xml_tree = ET.parse(xml_file_path)
    mediaID = xml_tree.getroot().find('MediaId').text
    classID = xml_tree.getroot().find('ClassId').text

    return mediaID, classID



process_wav_files()



