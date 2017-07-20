#!/bin/bash

dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/decrypt/logs \
--image gcr.io/gbsc-gcp-project-mvp/gs_decrypt_dflow \
--disk-size 800 \
--script command_scripts/decrypt.sh \
--tasks ../inputs/process/decrypt/gs-bina-tar-pgp.tsv
