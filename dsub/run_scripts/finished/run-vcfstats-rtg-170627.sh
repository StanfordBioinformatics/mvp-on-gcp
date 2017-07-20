#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/rtg-tools/logs/170626 \
--image gcr.io/gbsc-gcp-project-mvp/rtg-tools:1.0 \
--command 'rtg vcfstats ${INPUT} > ${OUTPUT}' \
--table ../inputs/process/vcfstats/rtg-tools/gs-bina-vcfstats-rtg-missing-170626.tsv \
