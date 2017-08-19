#!/bin/bash

dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/concat/logs/${date_stamp} \
--image gcr.io/${mvp_project}/text-to-table:0.2.0 \
--disk-size 100 \
--vars-include-wildcards \
--input INPUT_FILES=gs://${mvp_bucket}/dsub/vcfstats/text-to-table/objects/*_vcfstats.txt.csv \
--output CONCAT_FILE=gs://${mvp_bucket}/dsub/vcfstats/concat/objects/concat_rtg_vcfstats.txt.csv \
--command 'cat ${INPUT_FILES} > ${CONCAT_FILE}' \
--dry-run
