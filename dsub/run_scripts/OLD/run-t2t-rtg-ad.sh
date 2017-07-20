#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/text2table/ad \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
--table ../inputs/text_to_table/rtg_vcfstats/gs_bina_rtg_ad.tsv
