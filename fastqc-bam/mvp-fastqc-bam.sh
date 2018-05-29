#!/bin/bash

###############################################################
# 			FastQC
#					
#					- 5/01/2018	
#					- Jina
###############################################################

## 0. check that environment variables have been loaded correctly
echo "Date stamp: ${date_stamp}"
echo "Home directory: ${mvp_hub}"
echo "Project: ${mvp_project}"
echo "Bucket: ${mvp_bucket}"
echo "Zone: ${mvp_zone}"
echo "Hub: ${mvp_hub}"

## 1. Run FastQC
# Create file accounting directory it doesn't already exist
accounting_dir="${mvp_hub}/fastqc-bam/file-accounting/${data_stamp}"
mkdir -p ${accounting_dir}
dsub_inputs_dir="${mvp_hub}/fastqc-bam/dsub-inputs"

# dsub -- FastQC
dsub \
    --zones "${mvp_zone}" \
    --project ${mvp_project} \
    --logging gs://${mvp_bucket}/dsub/fastqc-bam/fastqc/logs/${date_stamp} \
    --image gcr.io/${mvp_project}/fastqc:1.01 \
    --disk-size 500 \
    --script ${mvp_hub}/fastqc-bam/dsub-scripts/fastqc.sh \
    --tasks ${dsub_inputs_dir}/fastqc/gs-bina-fastqc-bam-missing-test.tsv ${dsub_range} \
    #--command 'fastqc ${INPUT} --outdir=$(dirname ${OUTPUT})' \
    #--wait
