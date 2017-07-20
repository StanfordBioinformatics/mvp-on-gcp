#!/bin/bash

dsub \
--zones "us-east1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/sha1sum/logs/170629 \
--image ubuntu:16.10 \
--disk-size 500 \
--script command_scripts/sha1sum.sh \
--tasks ../inputs/process/sha1sum/run-sha1-check-170629.tsv 1501-2008\
