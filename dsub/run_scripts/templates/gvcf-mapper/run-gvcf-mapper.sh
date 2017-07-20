#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/gvcfMapper \
--image gcr.io/gbsc-gcp-project-mvp/gvcf-mapper:1.4 \
--command 'gvcf-mapper-cl.py -g ${INPUT} -o ${OUTPUT}' \
--table ../test_inputs/gs_bina_gvcf_170509_tail01.txt.tsv \
--wait
