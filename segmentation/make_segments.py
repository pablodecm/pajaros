#! /bin/python2

import argparse
from process_files import process_wav_files
import pickle

parser = argparse.ArgumentParser(description='Get segments from wav files.')
parser.add_argument('-fl','--file_list', required=True,
                    help='Path to a pickle file with a list files')
parser.add_argument('-o','--output_path',required=True,
                    help='Path to desired output folder')
parser.add_argument('-fr','--fr', type=int,
                    help='Range of files in the list to process')
parser.add_argument('-to','--to', type=int,
                    help='Range of files in the list to process')

args = parser.parse_args()

# load file list from file
with open(args.file_list) as f:
    wav_file_list = pickle.load(f)

# process files
process_wav_files(wav_file_list[args.fr : args.to], args.output_path)

# notify that processing has finished
print "Process has finished!"



