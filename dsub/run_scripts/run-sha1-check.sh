#!/bin/bash

../../dsub \
--zones "us-east1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/sha1sum/logs/170629 \
--image ubuntu:16.10 \
--disk-size 800 \
--script command_scripts/sha1sum.sh \
--input-recursive INPUT_PATH=gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/40013463/20121d0d-136b-4f4e-acae-667132b8b89a/QC \
--output PASS_FILES=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/sha1sum/objects/40013463_pass.txt \
--output FAIL_FILES=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/sha1sum/objects/40013463_fail.txt

