# Tandem repeat identification

1. scripts for detecting [telomere](tandemrepeat-quantification/scripts/telomere.sh):
   
   Split the pseudomolecule fasta file (using the split-fasta python package) for each NAM line to individual chromosome sequences in FASTA format : 
  
   ```bash
   splitfasta pseudomolecule.fasta
   ```

   Telomere script: This script takes as input the chromosome sequences in FASTA format and generates output files in txt format containing telomeric coordinates      for the small and long end of the input chromosome sequence. The script should be run in a directory containing the input FASTA files. 
   
   ```bash
   sh telomere.sh
   ```

2. scripts for sub-telomere ([1](tandemrepeat-quantification/scripts/subtelomeres_clusters.sh), [2](tandemrepeat-quantification/scripts/subtelomeres_blast.sh)) detection.

   Split the pseudomolecule fasta file (using the split-fasta python package) for each NAM line to individual chromosome sequences in FASTA format : 
  
   ```bash
   splitfasta pseudomolecule.fasta
   ```
   Subtelomeres BLAST script: This script takes as input the sequence files of each subtelomeric sequences and the chromosome sequence in FASTA format and blast        each subtelomeric sequence to the chromosome sequence. The blast hits are then filtered based on query coverage (>=80%) and %identity (>=80%). The coordinates of    the filtered blast hits are extracted and sorted to generate sorted bed files. The script should be run in a directory containing the input FASTA files. 
   
    ```bash
    sh subtelomeres_blast.sh
    ```
   Subtelomeres Clusters script: This script takes as input the sorted bed files generated by the Subtelomeres BLAST script and cluster the blast hits using            bedtools. It generates output files in txt format containing the start and stop boundaries of subtelomeric array on the small and long arm of each chromosome.      This script should be run in a directory containing the bed files generated in the previous BLAST step.
   
   ```bash
   sh subtelomeres_clusters.sh
   ```
   
3. [TE quantification](tandemrepeat-quantification/scripts/TE_quantification.sh) and [repeat estimation](tandemrepeat-quantification/scripts/illumina_repeat_estimation.sh) scripts
4. [Plotting](tandemrepeat-quantification/scripts/stacked_barplot.R)
