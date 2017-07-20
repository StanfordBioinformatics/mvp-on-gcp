#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/gvcfMapper/ad \
--image gcr.io/gbsc-gcp-project-mvp/gvcf-mapper:1.4 \
--command 'gvcf-mapper-cl.py -g ${INPUT} -o ${OUTPUT}' \
--table ../inputs/gvcf_mapper/gs_bina_gvcf_greg_paul/gs_bina_gvcf_greg_paul_l500/gs_bina_gvcf_greg_paul_ad.tsv
