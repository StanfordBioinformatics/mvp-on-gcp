#!/bin/bash

../../dsub \
--zones "us-east1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/concat/logs/170628 \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--disk-size 100 \
--script command_scripts/text-to-table.sh \
--input INPUT_FILES=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/rtg-tools/objects/*_vcfstats.txt \
--output CONCAT_FILE=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/concat/concat_vcfstats.txt.csv \
--env SCHEMA=rtg_vcfstats \
--env SERIES=vcfstats-170628 \

