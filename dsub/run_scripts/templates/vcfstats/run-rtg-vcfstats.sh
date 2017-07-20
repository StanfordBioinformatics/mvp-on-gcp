#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/rtgVcfstats \
--image gcr.io/gbsc-gcp-project-mvp/rtg-tools:1.0 \
--command 'gvcf-mapper-cl.py -g ${INPUT} -o ${OUTPUT}' \
--table ../inputs/rtg_vcfstats/*.tsv \
--wait
