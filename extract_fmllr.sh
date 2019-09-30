#!/bin/bash

. ./cmd.sh
[ -f path.sh ] && . ./path.sh
set -e


data=arctic
gmmdir=exp/tri3
data_fmllr=zy-data-fmllr-tri3
. utils/parse_options.sh || exit 1;

feats_nj=2
decode_nj=2

#echo ===========================================
#echo "         MFCC Feature Extration          "
#echo ===========================================
#
#
#mfccdir=${data}/mfcc
#
#steps/make_mfcc.sh --cmd "$train_cmd" --nj $feats_nj ${data} exp/make_mfcc/arctic $mfccdir
#steps/compute_cmvn_stats.sh $data exp/make_mfcc/arctic $mfccdir



steps/decode_fmllr.sh --nj "$decode_nj" --cmd "$decode_cmd" --skip-scoring true\
 exp/tri3/graph $data exp/tri3/decode_${data}


dir=$data_fmllr

steps/nnet/make_fmllr_feats.sh --nj 2 --cmd "$train_cmd" \
   --transform-dir $gmmdir/decode_${data} \
   $dir $data $gmmdir $dir/log $dir/data || exit 1

