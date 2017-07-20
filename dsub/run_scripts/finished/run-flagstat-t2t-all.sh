#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/text-to-table/logs/all \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
--table ../inputs/process/flagstat/text-to-table/gs-bina-flagstat-t2t-170519.tsv
