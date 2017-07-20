#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/fastqc/logs/ae \
--image gcr.io/gbsc-gcp-project-mvp/fastqc:1.01 \
--disk-size 500 \
--script command_scripts/fastqc.sh \
--table ../inputs/process/fastqc-bam/fastqc/gs-fastqc-data-missing-170518.txt \
