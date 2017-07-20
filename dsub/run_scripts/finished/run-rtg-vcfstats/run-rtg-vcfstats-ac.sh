#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/rtgVcfStats/logs/ac \
--image gcr.io/gbsc-gcp-project-mvp/rtg-tools:1.0 \
--command 'rtg vcfstats ${INPUT} > ${OUTPUT}' \
--table ../inputs/rtg_vcfstats/gs_bina_gvcf_greg_paul/gs_bina_gvcf_greg_paul_l500/gs_bina_gvcf_greg_paul_ac.tsv \
#--wait
