#!/bin/bash

../../dsub \
--zones "us-east1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/samtools/logs/ac \
--image gcr.io/gbsc-gcp-project-mvp/samtools \
--disk-size 500 \
--command 'samtools flagstat ${INPUT} > ${OUTPUT}' \
--table ../inputs/process/flagstat/samtools/gs-bina-flagstat-samtools-ac.tsv \
