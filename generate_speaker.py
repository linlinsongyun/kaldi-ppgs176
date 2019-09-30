  import os
import sys
import glob
import numpy as np

############ assume wav_root/speaker/wav_name ############
## Target: generate (wav_path, speaker) files
if (len(sys.argv)-1 != 2):
  print ("Usage: $0 <wav_root> <save_path>")
  print ("e.g. $0 ../../ICASSP5/database/wav ./speaker.txt")
  exit(1)

wav_dir = sys.argv[1]
save_path = sys.argv[2]

output = open(save_path, 'w')
for sub_wav_dir in glob.glob(wav_dir+'/*'):
    print("sub+wav_dir", sub_wav_dir)
    speaker = os.path.split(sub_wav_dir)[-1]
    print("speaker", speaker)
    #import pdb;pdb.set_trace()
    # if speaker is int, then convert to str
    if speaker.isdigit(): speaker = "speaker%05d" %(int(speaker))
    assert speaker.isdigit()==False
    for wav_path in glob.glob(sub_wav_dir+'/*'):
        print("wav_path",wav_path)
        wav_name = os.path.split(wav_path)[-1]
	print("wav_name",wav_name)
        wave_name, wav_type = wav_name.split('.')
	print("wave_name,wav_type",wave_name, wav_type)
        if wav_type in ['wav', 'sph', 'flac']: output.write("%s %s\n" %(wav_path, speaker))
output.close()


