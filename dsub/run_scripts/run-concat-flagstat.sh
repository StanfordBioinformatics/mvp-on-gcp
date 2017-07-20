#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/concat/logs \
--image gcr.io/gbsc-gcp-project-mvp/samtools \
--disk-size 100 \
--script command_scripts/concat.sh \
--input INPUT_FILES=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/text-to-table/objects/*alignments.bam.flagstat.tsv.csv \
--output CONCAT_FILE=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/concat/objects/concat_alignments.bam.flagstat.tsv.csv
