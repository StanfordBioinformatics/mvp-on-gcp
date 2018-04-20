# mvp-on-gvp
Tools used to process MVP data on Google Cloud Platform

## Background
This code was generated as part of the Department of Veteran's Affairs Million Veteran's Program. As part of this program, whole-genome sequencing was performed on genetic samples from 1902 individuals. Sequencing was done by Personalis and the data delivered to Bina for variant-calling and further analyses. These included generation of quality-control metrics, identification of copy-number variants, and analysis of structural variants. Results from Bina analyses were delivered to Stanford via encrypted tar archives uploaded to a shared Google Cloud Storage bucket.

The code here was used to decrypt and extract the results, validate the integrity of the data, and then generate cohort-level quality control (QC) metrics. Data integrity was verified by comparing sha1 checksums and file sizes against those reported by Bina. Three software packages were used to generate QC metrics; FastQC, Samtools Flagstat, and Real-time Genomcis VCFstats. Each analysis was performed on the individual sample level after which results from all samples were combined. 

## Introduction
The code used to perform each operation has been added to individual Jupyter notebooks. Clone this repo, navigate to an task directory (i.e. fastqc-bam), and run the Jupyter notebook, to get started.

## Getting Started
1. Clone the mvp-on-gcp repo
```
git clone https://github.com/StanfordBioinformatics/mvp-on-gcp.git
```

2. Create and activate a Python virtualenv (optional but strongly recommended).
```
# (You can do this in a directory of your choosing.)
virtualenv -p /usr/bin/python/3.5 --no-site-packages mvp_libs
source mvp_libs/bin/activate
# source mvp-profile.sh
```
3. Install Jupyter notebooks and Jupyter kernel for bash
```
pip3 install jupyter
pip3 install bash_kernel
```

4. Launch Jupyter notebook
```
jupyter notebook
```
