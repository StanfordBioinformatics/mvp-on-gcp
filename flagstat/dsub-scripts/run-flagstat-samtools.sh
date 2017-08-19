#!/bin/bash

dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/flagstat/samtools/logs/${date_stamp} \
--image gcr.io/${mvp_project}/samtools \
--disk-size 1000 \
--command 'samtools flagstat ${INPUT} > ${OUTPUT}' \
--tasks ${mvp_hub}/flagstat/dsub-inputs/samtools/gs-bina-flagstat-missing-${date_stamp}.tsv ${dsub_range}\
--dry-run
