#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/TASK-NAME/concat/logs \
--image gcr.io/gbsc-gcp-project-mvp/samtools \
--disk-size 100 \
--script command_scripts/concat.sh \
--input INPUT_FILES=gs://PATH/TO/CSV/FILES \
--output CONCAT_FILE=gs://PATH/TO/CONCAT/FILE
