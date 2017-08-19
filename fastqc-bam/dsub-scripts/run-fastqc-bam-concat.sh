#!/bin/bash

dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/concat/logs/${date_stamp} \
--image gcr.io/${mvp_project}/text-to-table:0.2.0 \
--disk-size 100 \
--vars-include-wildcards \
--input INPUT_FILES=gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects/*alignments.bam.fastqc_data.txt.csv \
--output CONCAT_FILE=gs://${mvp_bucket}/dsub/fastqc-bam/concat/objects/concat_alignments.bam.fastqc_data.txt.csv \
--command 'cat ${INPUT_FILES} > ${CONCAT_FILE}' \

