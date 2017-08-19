vcfstats
What do I need to do?
Get list of all variants.gvcf.gz files: IN-PROGRESS
Get list of all samples?
Get list of all rtg_vcfstats.txt files
Convert to sample lists
Find difference between lists
Use make-batch-tsv-from-input-sample.py to generate dsub batch input

Code
Rtg-tools Vcfstats

#####
# Set date stamp to be used in subsequent steps
#####
date_stamp=$(date "+%Y%m%d")

#####
# Get list of gvcf files (& sample IDs) on GCS
#####
$ gsutil ls gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/*/*/VariantCalling/variants.gvcf.gz > gs-bina-gvcf-${date_stamp}.txt
$ cut -d'/' -f6 gs-bina-gvcf-${date_stamp}.txt > gs-bina-gvcf-sample-ids-${date_stamp}.txt

#####
# Get list of gvcf files that need vcfstats
#####
$ gsutil ls gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/rtg-tools/objects/*_rtg_vcfstats.txt > gs-bina-vcfstats-rtg-${date_stamp}.txt
$ cut -d '/' -f8 gs-bina-vcfstats-rtg-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-vcfstats-rtg-sample-ids-${date_stamp}.txt
$ diff --new-line-format="" --unchanged-line-format "" \
<(sort gs-bina-gvcf-sample-ids-${date_stamp}.txt) \
<(sort gs-bina-vcfstats-rtg-sample-ids-${date_stamp}.txt) \
> gs-bina-vcfstats-rtg-missing-sample-ids-${date_stamp}.txt
$ grep -F -f gs-bina-vcfstats-rtg-missing-sample-ids-${date_stamp}.txt gs-bina-gvcf-${date_stamp} > gs-bina-vcfstats-rtg-missing-${date_stamp}.txt

#####
# Create dsub TSV input file
#####
$ ./make-batch-tsv-from-input-sample.py -i file_accounting/vcfstats/gs-bina-vcfstats-rtg-missing-${date_stamp}.txt -t inputs/process/vcfstats/rtg-tools/gs-bina-vcfstats-rtg-missing-${date_stamp}.tsv -o gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/rtg-tools/objects -s rtg_vcfstats.txt

#####
# Run dsub tasks
#####
$ dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/vcfstats/rtg-tools/logs/20${date_stamp} \
--image gcr.io/gbsc-gcp-project-mvp/rtg-tools:1.0 \
--command 'rtg vcfstats ${INPUT} > ${OUTPUT}' \
--tasks ../inputs/process/vcfstats/rtg-tools/gs-bina-vcfstats-rtg-missing-${date_stamp}.tsv 1 \
#--dry-run

Text-to-table

date_stamp=$(date "+%Y%m%d")
bucket="gbsc-gcp-project-mvp-phase-2-data"
project=”gbsc-gcp-project-mvp”

#####
# Get list of vcfstats files (& sample IDs) on GCS
#####
$ cd file-accounting/vcfstats
$ gsutil ls gs://${mvp_bucket}/dsub/vcfstats/rtg-tools/objects/*_rtg_vcfstats.txt > gs-bina-vcfstats-rtg-${date_stamp}.txt
$ gsutil ls gs://${mvp_bucket}/dsub/vcfstats/text-to-table/objects/*_rtg_vcfstats.txt.csv > gs-bina-vcfstats-csv-${date_stamp}.txt
$ cut -d'/' -f8 gs-bina-vcfstats-rtg-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-vcfstats-rtg-sample-ids-${date_stamp}.txt
$ cut -d'/' -f8 gs-bina-vcfstats-csv-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-vcfstats-csv-sample-ids-${date_stamp}.txt

#####
# Convert file lists to sample lists and get missing samples
#####
$ diff --new-line-format="" --unchanged-line-format "" <(sort gs-bina-vcfstats-rtg-sample-ids-${date_stamp}.txt) <(sort gs-bina-vcfstats-csv-sample-ids-${date_stamp}.txt) > gs-bina-vcfstats-csv-sample-ids-missing-${date_stamp}.txt
$ grep -F -f gs-bina-vcfstats-csv-sample-ids-missing-${date_stamp}.txt gs-bina-vcfstats-rtg-${date_stamp}.txt > gs-bina-vcfstats-csv-missing-${date_stamp}.txt

#####
# Convert file list to dsub TSV files
#####
$ cd bin
$ ./make-batch-tsv-from-input-file.py \
-i ../file-accounting/vcfstats/${date_stamp}/gs-bina-vcfstats-csv-missing-${date_stamp}.txt \
-t ../file-accounting/vcfstats/dsub-inputs/text-to-table/gs-bina-vcfstats-csv-missing-${date_stamp}.tsv \
-o gs://${mvp_bucket}/dsub/vcfstats/text-to-table/objects \
-s csv \
-c rtg_vcfstats \
-e rtg-vcfstats-${date_stamp}

#####
# Run dsub task
#####
$ dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/text-to-table/logs/${date_stamp} \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
--tasks ../file-accounting/vcfstats/dsub-inputs/text-to-table/gs-bina-vcfstats-csv-missing-${date_stamp}.tsv ${dsub_range} \
#--dry-run

#####
# Watch dsub task
#####
$ watch -n15 "${dstat_command}"

#####
# Get new list of completed results files
#####
$ cd ../file_accounting/vcfstats
$ gsutil ls gs://${mvp_bucket}/dsub/vcfstats/text-to-table/objects/*_rtg_vcfstats.txt.csv > gs-bina-vcfstats-csv-${date_stamp}.txt

Concat

#####
# Run dsub task
#####
$ dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/concat/logs/${date_stamp} \
--image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
--disk-size 100 \
--script dsub-scripts/text-to-table.sh \
--input INPUT_FILES=gs://${mvp_bucket}/dsub/vcfstats/text-to-table/objects/*_vcfstats.txt.csv \
--output CONCAT_FILE=gs://${mvp_bucket}/dsub/vcfstats/concat/concat_vcfstats.txt.csv \
--env SCHEMA=rtg_vcfstats \
--env SERIES=vcfstats-${date_stamp} \

