#!/bin/bash

../../dsub \
--zones "us-east1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/text-to-table/logs/ac \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
--table ../inputs/process/vcfstats/text-to-table/gs-bina-vcfstats-txt-170517-l500/gs-bina-vcfstats-t2t-ac.tsv
