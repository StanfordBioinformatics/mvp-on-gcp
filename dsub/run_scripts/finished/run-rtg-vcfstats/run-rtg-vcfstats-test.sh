#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/rtgVcfStats/logs/test \
--image gcr.io/gbsc-gcp-project-mvp/rtg-tools:1.0 \
--command 'rtg vcfstats ${INPUT} > ${OUTPUT}' \
--table ../test_inputs/rtgVcfStats_test_n10.tsv \
#--wait
