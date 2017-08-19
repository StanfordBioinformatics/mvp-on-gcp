#!/bin/bash

dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/text-to-table/logs/${date_stamp} \
--image gcr.io/${mvp_project}/text-to-table:0.2.0 \
--command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
--tasks ${mvp_hub}/vcfstats/dsub-inputs/text-to-table/gs-bina-vcfstats-csv-missing-${date_stamp}.tsv ${dsub_range} \
--dry-run
