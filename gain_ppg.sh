#!/bin/bash


. ./cmd.sh

[ -f path.sh ] && . ./path.sh
set -e

if [ $# != 2 ] ; then 
	echo "USAGE: $0 wav_path(or speaker_path) type"
	exit 1;
fi

if [[ "$2" = "1" ]] ; then 
	wavdir=$1
	DataPre=1
	echo "1: without speaker"
elif [[ "$2" = "2" ]] ; then 
	speakerPath=$1
	DataPre=2
	echo "2: with speaker"
else
	echo "Error: type should set to be 1 or 2" 
	exit 1;
fi 



dir=exp/dnn4_pretrain-dbn_dnn_smbr
#kaldi_dir='/home/zhangying09/.jupyter/kaldi-master'
kaldi_dir=/opt/kaldi
stage=0
acwt=0.2
gmmdir=exp/tri3
data_fmllr=f1168-fmllr
add_frame_count=false


#data=arctic
data=f1168
gmmdir=exp/tri3


. utils/parse_options.sh || exit 1;

FIXDATA=1
feats_nj=2
decode_nj=1

if [ $DataPre -eq 1 ]; then
	echo ==========================================
	echo "get utt2spk, DataPre start on" `date`
	echo ==========================================

	python make_data.py $wavdir $data
	utils/utt2spk_to_spk2utt.pl $data/utt2spk > $data/spk2utt || exit 1
	utils/spk2utt_to_utt2spk.pl $data/spk2utt > $data/utt2spk || exit 1

	echo ===== data preparatin finished successfully `date`==========
else
	echo ==========================================
	echo "get utt2spk, DataPre start on" `date`
	echo ==========================================
	python make_data_speaker.py $speakerPath $data
	$kaldi_dir/egs/timit/s5/utils/utt2spk_to_spk2utt.pl $data/utt2spk > $data/spk2utt || exit 1
	$kaldi_dir/egs/timit/s5/utils/spk2utt_to_utt2spk.pl $data/spk2utt > $data/utt2spk || exit 1

	echo ===== data preparatin finished successfully `date`==========
fi


if [ $FIXDATA -eq 1 ]; then
    echo ==========================================
	echo "sorted spk2utt ... : fix_data_dir start on" `date`
	echo ==========================================
    $kaldi_dir/egs/timit/s5/utils/fix_data_dir.sh $data
	echo ====== fix_data_dir finished successfully `date` ==========
fi


if [ $stage -le 0 ];then
    echo "step 0"
    mfccdir=${data}/mfcc
    steps/make_mfcc.sh --cmd "$train_cmd" --nj $feats_nj ${data} exp/make_mfcc/arctic $mfccdir
    steps/compute_cmvn_stats.sh $data exp/make_mfcc/arctic $mfccdir
fi


if [ $stage -le 1 ];then

echo "step 1"
steps/decode_fmllr.sh --nj "$decode_nj" --cmd "$decode_cmd" --skip-scoring true\
 exp/tri3/graph $data exp/tri3/decode_${data} || exit 1;


dir=$data_fmllr

steps/nnet/make_fmllr_feats.sh --nj 1 --cmd "$train_cmd" \
   --transform-dir $gmmdir/decode_${data} \
   $dir $data $gmmdir $dir/log $dir/data || exit 1


fi


if [ $stage -le 2 ]; then
 echo "step2" 
 dir=exp/dnn4_pretrain-dbn_dnn_smbr
  # Decode
    steps/nnet/decode_zyf.sh --nj 1 --cmd "$decode_cmd" \
      --nnet $dir/6.nnet --acwt $acwt --add_frame_count $add_frame_count\
      $gmmdir/graph $data_fmllr $dir/decode_dev_it6 || exit 1;
fi

echo "end"
