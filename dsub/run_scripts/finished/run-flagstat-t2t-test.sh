#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/text-to-table/logs/test \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
--table ../test_inputs/gs-bina-flagstat-t2t-test-n9.tsv
