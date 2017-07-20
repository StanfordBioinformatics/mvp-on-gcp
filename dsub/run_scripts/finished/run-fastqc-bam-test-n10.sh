#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/fastqc/test/logs \
--image gcr.io/gbsc-gcp-project-mvp/fastqc:1.01 \
--script command_scripts/fastqc.sh \
--table ../test_inputs/gs-bina-fastqc-bam-test-n10.tsv \
#--wait
