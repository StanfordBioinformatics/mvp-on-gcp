#!/bin/bash

###############################################################
# 			Vcfstats
#					
#					- 4/20/2018	
#					- Jina
###############################################################

## 0. check that environment variables have been loaded correctly
echo "Date stamp: ${DATE_STAMP}"
echo "Home directory: ${MVP_HUB}"
echo "Project: ${MVP_PROJECT}"
echo "Bucket: ${MVP_BUCKET}"
echo "Zone: ${MVP_ZONE}"
echo "Hub: ${MVP_HUB}"

## 1. Run rtg-tools vcfstats

# Create file accounting directory it doesn't already exist
accounting_dir="${MVP_HUB}/vcfstats/file-accounting/${DATE_STAMP}"
mkdir -p ${accounting_dir}
dsub_inputs_dir="${MVP_HUB}/vcfstats/dsub-inputs"

echo "Accounting_dir: ${accounting_dir}"
echo "Input_dir: ${dsub_inputs_dir}"

# Get list of sample IDs for gvcf files that already exist on Google Cloud Storage
gsutil ls gs://${MVP_BUCKET}/*/*/VariantCalling/variants.gvcf.gz > ${accounting_dir}/gs-gvcf-${DATE_STAMP}.txt
cut -d'/' -f6 ${MVP_HUB}/vcfstats/file-accounting/${DATE_STAMP}/gs-gvcf-${DATE_STAMP}.txt > ${accounting_dir}/gs-gvcf-sample-ids-${DATE_STAMP}.txt

# Get list sample IDs for vcfstats files that already exist on Google Cloud Storage
gsutil ls gs://${mvp_bucket}/dsub/vcfstats/rtg-tools/objects/*_rtg_vcfstats.txt \
    > ${accounting_dir}/gs-vcfstats-rtg-${DATE_STAMP}.txt
cut -d '/' -f8 ${accounting_dir}/gs-vcfstats-rtg-${DATE_STAMP}.txt \
    | cut -d'_' -f1 > ${accounting_dir}/gs-vcfstats-rtg-sample-ids-${DATE_STAMP}.txt

# Get difference between lists of sample IDs to find out which samples are missing vcfstats files
diff --new-line-format="" --unchanged-line-format "" \
    <(sort ${accounting_dir}/gs-gvcf-sample-ids-${DATE_STAMP}.txt) \
    <(sort ${accounting_dir}/gs-vcfstats-rtg-sample-ids-${DATE_STAMP}.txt) \
    > ${accounting_dir}/gs-vcfstats-rtg-missing-sample-ids-${DATE_STAMP}.txt
grep -F \
    -f ${accounting_dir}/gs-vcfstats-rtg-missing-sample-ids-${DATE_STAMP}.txt \
    ${accounting_dir}/gs-gvcf-${DATE_STAMP}.txt \
    > ${accounting_dir}/gs-vcfstats-rtg-missing-${DATE_STAMP}.txt

# Create dsub TSV task file to generate missing vcfstats files
mkdir -p ${dsub_inputs_dir}/rtg-tools
${MVP_HUB}/bin/make-batch-tsv-from-input-sample.py \
    -i ${accounting_dir}/gs-vcfstats-rtg-missing-${DATE_STAMP}.txt \
    -t ${dsub_inputs_dir}/rtg-tools/gs-vcfstats-rtg-missing-${DATE_STAMP}.tsv \
    -o gs://${MVP_BUCKET}/dsub/vcfstats/rtg-tools/objects \
    -s rtg_vcfstats.txt

