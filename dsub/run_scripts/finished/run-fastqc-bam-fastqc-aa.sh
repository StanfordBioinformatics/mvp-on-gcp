#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/fastqc/logs/aa \
--image gcr.io/gbsc-gcp-project-mvp/fastqc:1.01 \
--script command_scripts/fastqc.sh \
--table ../inputs/process/fastqc-bam/fastqc/gs_bina_bam_170517_l500/gs_bina_bam_aa \
