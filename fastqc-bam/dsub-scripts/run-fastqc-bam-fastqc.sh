#!/bin/bash

dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/fastqc-bam/fastqc/logs/${date_stamp} \
--image gcr.io/${mvp_project}/fastqc:1.01 \
--disk-size 500 \
--script fastqc.sh \
--tasks ${mvp_hub}/fastqc-bam/dsub-inputs/fastqc/gs-bina-fastqc-data-missing-${date_stamp}.tsv ${dsub_range}\
