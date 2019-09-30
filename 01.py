import os
import sys
#wav_dir = os.getcwd()
wav_dir = sys.argv[1]
#os.system('cd %s' % wav_dir)
#wav_dir = os.getcwd()
#print("wav_dir",wav_dir)



'''

for fi in os.listdir(wav_dir):
    if fi.endswith('slt.wav'):
        utt_id = fi.split('.wav')[0]
        wav_path = os.path.join(wav_dir, fi)
 
        #wav_dir.split('/')[-1]
        #print('label', label)
        os.system('echo %s %s >> wav.scp' %(utt_id, wav_path))
        os.system('echo %s %s >> utt2spk' %(utt_id, 'slt'))
    if fi.endswith('bdl.wav'):
        utt_id = fi.split('.wav')[0]
        wav_path = os.path.join(wav_dir, fi)

        #wav_dir.split('/')[-1]
        #print('label', label)
        os.system('echo %s %s >> wav.scp' %(utt_id, wav_path))
        os.system('echo %s %s >> utt2spk' %(utt_id, 'bdl'))
'''

for f1 in os.listdir(wav_dir):
    f1_path = os.path.join(wav_dir, f1)
    print("f1_path", f1_path)
    print('f1-lable', f1)
    
    for fi in os.listdir(f1_path):
        if fi.endswith('.wav'):
            utt_id = fi.split('.wav')[0]
            wav_path = os.path.join(f1_path, fi)
            label = f1+'p'
            
            os.system('echo %s %s >> wav.scp' %(utt_id, wav_path))
            os.system('echo %s %s >> utt2spk' %(utt_id, label))
     #f2_path = os.path.join(f1_path, f2)


