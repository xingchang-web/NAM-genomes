#!/bin/bash
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
source /work/LAS/mhufford-lab/arnstrm/programs/sourceme
#cp /work/LAS/mhufford-lab/arnstrm/programs/gm_key_64 ~/.gm_key
conda activate braker
genome="$1"
bam="$2"
proteins="$3"
nam=$(echo ${bam%.*} | sed 's/merged_//g')
today=$(date +"%Y%m%d")
GENEMARK_PATH="/work/LAS/mhufford-lab/arnstrm/programs/genemark-et-4.33/bin"
braker.pl \
   --genome=$genome \
   --bam=$bam \
   --prot_seq=${proteins} \
   --prg=gth \
   --gth2traingenes \
   --species=${nam}_prot-rna_${today}.3 \
   --softmasking \
   --cores 36 \
   --gff3


