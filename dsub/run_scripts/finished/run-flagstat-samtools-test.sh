#!/bin/bash

../../dsub \
--zones "us-east1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/samtools/logs/test \
--image gcr.io/gbsc-gcp-project-mvp/samtools \
--disk-size 500 \
--command 'samtools flagstat ${INPUT} > ${OUTPUT}' \
--table ../test_inputs/gs-bina-flagstat-samtools-test.tsv \
