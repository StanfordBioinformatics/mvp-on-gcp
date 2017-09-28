#!/bin/bash

dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/rtg-tools/logs/${date_stamp} \
--image gcr.io/${mvp_project}/rtg-tools:1.0 \
--command 'rtg vcfstats ${INPUT} > ${OUTPUT}' \
--tasks ${mvp_hub}/vcfstats/dsub-inputs/rtg-tools/gs-bina-vcfstats-rtg-missing-${date_stamp}.tsv ${dsub_range} \
--dry-run

