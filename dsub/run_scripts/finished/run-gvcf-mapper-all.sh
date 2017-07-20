#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/gvcf-mapper/logs/all \
--image gcr.io/gbsc-gcp-project-mvp/gvcf-mapper:1.4 \
--command 'gvcf-mapper-cl.py -g ${INPUT} -o ${OUTPUT}' \
--table ../inputs/process/gvcf-mapper/gs_bina_gvcf_greg_paul/gs-bina-gvcf-mapper-170519.tsv 
