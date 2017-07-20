#!/bin/bash

../../dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/concat/rtgVcfStats \
--image gcr.io/gbsc-gcp-project-mvp/samtools \
--input INPUT_FILES=gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/*/*/VariantCalling/variants.gvcf.gz.rtg.vcfstats.csv \
--output CONCAT_FILE=gs://gbsc-gcp-project-mvp-phase-2-data/dsub/cocnat/rtgVcfStats/170512_rtg_vcfstats_concat.csv \
--script command_scripts/concat.sh 