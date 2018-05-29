#!/bin/bash

###############################################################
# 			Vcfstats
#					
#					- 4/20/2018	
#					- Jina
###############################################################

## 0. check that environment variables have been loaded correctly
echo "Date stamp: ${date_stamp}"
echo "Home directory: ${mvp_hub}"
echo "Project: ${mvp_project}"
echo "Bucket: ${mvp_bucket}"
echo "Zone: ${mvp_zone}"
echo "Hub: ${mvp_hub}"

## 1. Run rtg-tools vcfstats
# Create file accounting directory it doesn't already exist
accounting_dir="${mvp_hub}/vcfstats/file-accounting/${data_stamp}"
mkdir -p ${accounting_dir}
dsub_inputs_dir="${mvp_hub}/vcfstats/dsub-inputs"

## dsub - test
#dsub \
#  --project ${mvp_project} \
#  --zones ${mvp_zone} \
#  --logging gs://${mvp_bucket}/logs/ \
#  --output OUT=gs://${mvp_bucket}/hello_workd.txt \
#  --command 'echo "Hello World" > "${OUT}"' \
#  --wait

  #--logging gs://gbsc-gcp-lab-gbsc-group/logging/ \
  #--logging gs://${mvp_bucket}/dsub/vcfstats/rtg-tools/logs/${date_stamp} \
  #--logging gs://${mvp_bucket}/logs/\
  #--output OUT=gs://gbsc-gcp-lab-gbsc-group/output/out.txt \
  #--output OUT=gs://gbsc-gcp-project-mvp-group/for-jina/dsub/vcfstats/rtg-tools/objects/hello_world.txt \

## 1. dsub -- rtg-tool
dsub \
    --zones "${mvp_zone}" \
    --project ${mvp_project} \
    --logging gs://${mvp_bucket}/dsub/vcfstats/rtg-tools/logs/${date_stamp} \
    --image gcr.io/${mvp_project}/rtg-tools:1.0 \
    --command 'rtg vcfstats ${INPUT} > ${OUTPUT}' \
    --tasks ${dsub_inputs_dir}/rtg-tools/gs-bina-vcfstats-rtg-missing-test.tsv ${dsub_range} \
    --wait
    --dry-run
    #--tasks ${dsub_inputs_dir}/rtg-tools/gs-bina-vcfstats-rtg-missing-test_one.tsv ${dsub_range} \
    #--input INPUT=gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/400744881/2b2653a3-be13-49ee-94c8-44810268d9de/VariantCalling/variants.gvcf.gz \
    #--output OUTPUT=gs://gbsc-gcp-project-mvp-group/for-jina/dsub/vcfstats/rtg-tools/objects/400744881_rtg_vcfstats.txt \
