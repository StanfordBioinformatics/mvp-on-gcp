#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/gvcf-mapper/logs/test \
--image gcr.io/gbsc-gcp-project-mvp/gvcf-mapper:1.4 \
--command 'gvcf-mapper-cl.py -g ${INPUT} -o ${OUTPUT}' \
--table ../test_inputs/gs-bina-gvcf-mapper-test-n4.tsv 
