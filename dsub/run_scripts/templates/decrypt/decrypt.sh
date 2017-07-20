#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/decrypt \
--image gcr.io/gbsc-gcp-project-mvp/gs_decrypt_dflow:1.0 \
--script command_scripts/decrypt.sh \
--disk-size 800 \
--table ../inputs/process/decrypt/[].tsv
