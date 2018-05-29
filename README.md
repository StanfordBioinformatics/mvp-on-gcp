# mvp-on-gvp-practice_ver
This branch is intended to test mvp-on-gvp with a small number of samples

# Test Steps

## Tools for Quality Control
1. FastQC test
2. vcfstats test
3. flagstat test

## Coherence check with QC metrics  
1. Import the final output files from QC tools (concatenated csv files) on Google Bigquery
2. coherence check 

# Getting Started
* Clone the mvp-on-gcp repo

```
git clone https://github.com/StanfordBioinformatics/mvp-on-gcp/tree/practice_ver.git
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

	fastqc : mvp-on-gcp/fastqc-bam/mvp-fastqc-bam.ipynb

	vcfstats : mvp-on-gcp/vcfstats/mvp-vcfstats.ipynb
	
	flagstat : mvp-on-gcp/flagstat/mvp-flagstat.ipynb

		
## Coherence Check
* Import the concatenated csv files into BigQuery

* Install Datalab

	https://cloud.google.com/datalab/docs/quickstart
	
* Connect Datalab 

```
datalab connect [instance-name]
```

* Upload *.ipynb on datalab

	mvp-on-gcp/coherence-check/mvp-coherence-check.ipynb
	
* Import BigQuery tables into coherence-check ipynb
