#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/concat/logs \
--image gcr.io/gbsc-gcp-project-mvp/samtools \
--disk-size 100 \
--script command_scripts/concat.sh \
--input INPUT_FILES=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/text-to-table/objects/*fastqc_data.txt.csv \
--output CONCAT_FILE=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/concat/objects/fastqc-concat-170627.csv
