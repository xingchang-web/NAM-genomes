# BRAKER predictions


First round of BRAKER was run on hard-masked genome (speeds up the protein alignment), using the following files:

1. Mikado protein coding genes (peptides in fasta format)
2. RNAseq aligned using STAR (bam files)
3. hard-Masked NAM genome


The prediction was carried out using [script](scripts-braker/runBraker-prot-and-rnaseq.sh)


```bash
#!/bin/bash
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
source /work/LAS/mhufford-lab/arnstrm/programs/sourceme
#cp /work/LAS/mhufford-lab/arnstrm/programs/gm_key_64 ~/.gm_key
conda activate braker
genome="$1" # hard-masked
bam="$2" # RNAseq aligned bam
proteins="$3" # proteins fasta
nam=$(echo ${bam%.*} | sed 's/merged_//g')
today=$(date +"%Y%m%d")
echo "the profile created is: ${nam}_prot-rna_${today}.1"
GENEMARK_PATH="/work/LAS/mhufford-lab/arnstrm/programs/genemark-et-4.33/bin"
braker.pl \
   --genome=$genome \
   --bam=$bam \
   --prot_seq=${proteins} \
   --prg=gth \
   --gth2traingenes \
   --species=${nam}_prot-rna_${today}.1 \
   --softmasking \
   --cores 36 \
   --gff3
```

The profile created in this round will be used for the second round of BRAKER (alternatively, you can also use the `hintsfile.gff` and `protein_alignment_gth.gff3` generated in the previous round for this round as well.

For this round, you will need:

1. Unmasked genome
2. Either:
   (a) species profile created in the first round or
   (b) `protein_alignment_gth.gff3` and `hintsfile.gff` generated in the first round.

The script used is [here](scripts-braker/runBraker-pretrained.sh)


```bash
#!/bin/bash
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
source /work/LAS/mhufford-lab/arnstrm/programs/sourceme
#cp /work/LAS/mhufford-lab/arnstrm/programs/gm_key_64 ~/.gm_key
conda activate braker
genome="$1"
bam="$2"
#proteins="$3"
profile="$3"
nam=$(echo ${bam%.*} | sed 's/merged_//g')
today=$(date +"%Y%m%d")
GENEMARK_PATH="/work/LAS/mhufford-lab/arnstrm/programs/genemark-et-4.33/bin"
braker.pl \
   --genome=${genome} \
   --bam=${bam} \
   --species=${profile} \
   --skipAllTraining \
   --softmasking \
   --cores 36 \
   --gff3
```


<details><summary>If using alignment files, see here </summary>

The `hintsfile.gff` and `protein_alignment_gth.gff3` created in the first round can be provided and retrained on the whole genome as well (see script [here](scripts-braker/runBraker-with-aln-files.sh) ):

```bash
#!/bin/bash
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
source /work/LAS/mhufford-lab/arnstrm/programs/sourceme
#cp /work/LAS/mhufford-lab/arnstrm/programs/gm_key_64 ~/.gm_key
conda activate braker
genome="$1"
bam="$2" # hintsfile.gff
proteins="$3" #protein_alignment_gth.gff3
#profile="$3"
nam=$(echo ${bam%.*} | sed 's/merged_//g')
today=$(date +"%Y%m%d")
profile=${nam}_prot-rna_${today}.2
GENEMARK_PATH="/work/LAS/mhufford-lab/arnstrm/programs/genemark-et-4.33/bin"
braker.pl \
   --genome=${genome} \
   --hints=${bam} \
   --prot_aln=${proteins} \
   --species=${profile} \
   --softmasking \
   --cores 36 \
   --gff3
```
</details>



<details><summary> GTF to GFF error</summary> 

If you get the error saying that the conversion of GTF to GFF3 failed, 

```
gtf2gff.pl: transcript jg1.t1 has conflicting gene parents: and jg1
```

you can fix this file and convert it to GFF3 as follows.
The script [`fix_joingenes_gtf.pl`](https://github.com/Gaius-Augustus/Augustus/blob/master/scripts/fix_joingenes_gtf.pl) is needed.

```bash
fix_joingenes_gtf.pl < joingenes.gtf > joingenes.fixed.gtf
```

After this, the fixed joingenes output will contain the gene feature line and correctly formatted transcript line that is
 fully comptabile with `gtf2gff.pl`:

```bash
gtf2gff.pl < joingenes.fixed.gtf --gff3 --out=joingenes.gff3
```
</details>

### Post processing of BRAKER models

Additional structural improvements for the Mikado generated transcripts were completed using the PASA (v2.3.3) genome annotation tool. The inputs for PASA included 2,019,896 maize EST derived from genbank, linage specific Mikado transcripts, 69,163 B73 full length cDNA from genbank and 46,311 maize iso-seq transcripts from 11 developmental tissues that were filtered for intron retention. Details on how the evidence for PASA was curated is provided here:?? PASA updated the models, providing UTR extensions, novel and additional alternative isoforms. 

PASA was run in there steps:

Step 1. included aligning the evidence to the repeatmasked genome sequence. All the evidences were combined into a single fasta input, along with masked genome, pasa-config file and Full-length accession list to the script [pasa_run_1.sh](/gene-prediction/cshl-scripts/pasa_run_1.sh) 
```
qsub pasa_run_1.sh 
```

Step 2. included loading the pasa transcript assemblies to sqlite database for comparsion and updating the Mikado models. This was done using script [pasa_run_2.sh](/gene-prediction/cshl-scripts/pasa_run_2.sh)

```
qsub pasa_run_2.sh
```

Step 3. Lastly PASA was again run updating models from Step 2 usng the script [pasa_run_3.sh](/gene-prediction/cshl-scripts/pasa_run_3.sh)

```
qsub pasa_run_2.sh
```
