# mvp-on-gcp (personalis_ver)
This branch is intended to run mvp-on-gvp for personalis samples (normal)

## Tools for Quality Control
1. FastQC test
2. vcfstats test
3. flagstat test

## Getting Started
* Clone the mvp-on-gcp repo

```
git clone https://github.com/StanfordBioinformatics/mvp-on-gcp/tree/personalis_ver.git
```

## Run Quality Control tools

* Install dsub 

	https://github.com/DataBiosphere/dsub/blob/master/README.md

* Install Jupyter Notebook (If not installed already)

```
pip3 install jupyter
pip3 install bash_kernel
```
* Launch Jupyter Notebook

```
source dsub/dsub_libs/bin/activate
source mvp-on-gcp/mvp-profile.sh
jupyter notebook

```
* open *.ipynb file and run cells

  fastqc : mvp-on-gcp/fastqc-bam/mvp-fastqc-bam-personalis.ipynb

  vcfstats : mvp-on-gcp/vcfstats/mvp-vcfstats-personalis.ipynb

  flagstat : mvp-on-gcp/flagstat/mvp-flagstat-personalis.ipynb

