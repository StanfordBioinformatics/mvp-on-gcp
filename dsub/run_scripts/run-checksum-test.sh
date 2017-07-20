#!/bin/bash

dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-group/test/dsub_test/checksum/logs/40013463 \
--image ubuntu:16.10 \
--disk-size 800 \
--script command_scripts/checksum2.sh \
--tasks ../inputs/process/sha1sum/run-checksum-test.tsv \
#--dry-run
