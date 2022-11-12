#!bin/bash

cd ~/dc_workshop/data/ref_genome
wget https://zenodo.org/record/2582555/files/hg19.chr5_12_17.fa.gz
gunzip hg19.chr5_12_17.fa.gz
head data/ref_genome/hg19.chr5_12_17.fa
cd ~/dc_workshop/data$ mkdir datasets
wget https://zenodo.org/record/2582555/files/SLGFSK-N_231335_r1_chr5_12_17.fastq.gz
gunzip SLGFSK-N_231335_r1_chr5_12_17.fastq.gz
wget https://zenodo.org/record/2582555/files/SLGFSK-N_231335_r2_chr5_12_17.fastq.gz
gunzip SLGFSK-N_231335_r2_chr5_12_17.fastq.gz
wget https://zenodo.org/record/2582555/files/SLGFSK-T_231336_r1_chr5_12_17.fastq.gz
gunzip SLGFSK-T_231336_r1_chr5_12_17.fastq.gz
wget https://zenodo.org/record/2582555/files/SLGFSK-T_231336_r2_chr5_12_17.fastq.gz
gunzip SLGFSK-T_231336_r2_chr5_12_17.fastq.gz

bwa mem data/ref_genome/hg19.chr5_12_17.fa data/datasets/SLGFSK-N_231335_r1_chr5_12_17.fastq data/datasets/SLGFSK-N_231335_r2_chr5_12_17.fastq  > results/sam/SLGFSK-N_231335.aligned.sam
bwa mem data/ref_genome/hg19.chr5_12_17.fa data/datasets/SLGFSK-T_231336_r1_chr5_12_17.fastq data/datasets/SLGFSK-T_231336_r2_chr5_12_17.fastq  > results/sam/SLGFSK-T_231336.aligned.sam
samtools view -S -b results/sam/SLGFSK-N_231335.aligned.sam> results/sam/bam/SLGFSK-N_231335.aligned.bam
samtools view -S -b results/sam/SLGFSK-T_231336.aligned.sam> results/sam/bam/SLGFSK-T_231336.aligned.bam
samtools sort -o results/bam/SRR2584866.aligned.sorted.bam results/bam/SRR2584866.aligned.bam 
samtools sort -o results/sam/bam/SLGFSK-N_231335.aligned.sorted.bam results/sam/bam/SLGFSK-N_231335.aligned.bam 
samtools sort -o results/sam/bam/SLGFSK-T_231336.aligned.sorted.bam results/sam/bam/SLGFSK-T_231336.aligned.bam
samtools flagstat results/sam/bam/SLGFSK-N_231335.aligned.sorted.bam 
samtools flagstat results/sam/bam/SLGFSK-T_231336.aligned.sorted.bam
bcftools mpileup -O b -o results/sam/bam/bcf/SLGFSK-N_231335_raw.bcf \-f data/ref_genome/hg19.chr5_12_17.fa results/sam/bam/SLGFSK-N_231335.aligned.sorted.bam 
bcftools mpileup -O b -o results/sam/bam/bcf/SLGFSK-T_231336_raw.bcf \-f data/ref_genome/hg19.chr5_12_17.fa results/sam/bam/SLGFSK-T_231336.aligned.sorted.bam 
bcftools call --ploidy 1 -m -v -o results/sam/bam/bcf/vcf/SLGFSK-N_231335_variants.vcf results/sam/bam/bcf/SLGFSK-N_231335_raw.bcf 
bcftools call --ploidy 1 -m -v -o results/sam/bam/bcf/vcf/SLGFSK-T_231336_variants.vcf results/sam/bam/bcf/SLGFSK-T_231336_raw.bcf   
vcfutils.pl varFilter results/sam/bam/bcf/vcf/SLGFSK-N_231335_variants.vcf  > results/sam/bam/bcf/vcf/SLGFSK-N_231335_final_variants.vcf
vcfutils.pl varFilter results/sam/bam/bcf/vcf/SLGFSK-T_231336_variants.vcf  > results/sam/bam/bcf/vcf/SLGFSK-T_231336_final_variants.vcf
less -S results/sam/bam/bcf/vcf/SLGFSK-N_231335_final_variants.vcf
less -S results/sam/bam/bcf/vcf/SLGFSK-T_231336_final_variants.vcf
grep -v "#" results/sam/bam/bcf/vcf/SLGFSK-N_231335_final_variants.vcf | wc -l
grep -v "#" results/sam/bam/bcf/vcf/SLGFSK-T_231336_final_variants.vcf | wc -l
samtools index results/sam/bam/SLGFSK-N_231335.aligned.sorted.bam
samtools index results/sam/bam/SLGFSK-T_231336.aligned.sorted.bam
samtools tview results/sam/bam/SLGFSK-N_231335.aligned.sorted.bam data/ref_genome/hg19.chr5_12_17.fa
samtools tview results/sam/bam/SLGFSK-T_231336.aligned.sorted.bam data/ref_genome/hg19.chr5_12_17.fa

