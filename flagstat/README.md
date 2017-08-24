# Samtools Flagstat

# What do I need to do?
- Get list of sample IDs for all bam files on GCS
- Get list of sample IDs for all flagstat TSV files on GCS
- Compare lists to find samples missing flagstat files
- Use custom python script to create dsub TSV input file for missing samples
- Run dsub tasks

# Code
## 1. Flagstat

#### Source mvp environment file
```
source mvp-on-gcp.sh
```

#### Get list of bam files (& sample IDs) on GCS
```
mkdir ${mvp_hub}/file-accounting/flagstat/${date_stamp}
cd ${mvp_hub}/file-accounting/flagstat/${date_stamp}
gsutil ls gs://${mvp_bucket}/data/bina-deliverables/*/*/Recalibration/alignments.bam \
  > gs-bina-bam-${date_stamp}.txt
cut -d'/' -f6 gs-bina-bam-${date_stamp}.txt \
  > gs-bina-bam-sample-ids-${date_stamp}.txt
```

#### Get list of bam files that need flagstat
```
gsutil ls gs://${mvp_bucket}/dsub/flagstat/samtools/objects/*.flagstat.tsv \
  > gs-bina-flagstat-${date_stamp}.txt
cut -d'/' -f8 gs-bina-flagstat-${date_stamp}.txt \
  | cut -d'_' -f1 \
  > gs-bina-flagstat-sample-ids-${date_stamp}.txt
cut -d'/' -f6 gs-bina-bam-${date_stamp}.txt \
  > gs-bina-bam-sample-ids-${date_stamp}.txt
diff \
  --new-line-format="" \
  --unchanged-line-format "" \
  <(sort gs-bina-bam-sample-ids-${date_stamp}.txt) \
  <(sort gs-bina-flagstat-sample-ids-${date_stamp}.txt) > \
  gs-bina-flagstat-missing-sample-ids-${date_stamp}.txt
grep \
  -F \
  -f gs-bina-flagstat-missing-sample-ids-${date_stamp}.txt \
  gs-bina-bam-${date_stamp}.txt \
  > gs-bina-flagstat-missing-${date_stamp}.txt
```

#### Create dsub TSV input file
```
mkdir -p ${mvp_hub}/file-accounting/flagstat/dsub-inputs/samtools
cd ${mvp_hub}/bin
./make-batch-tsv-from-input-sample.py \
  -i ${mvp_hub}/file-accounting/flagstat/${date_stamp}/gs-bina-flagstat-missing-${date_stamp}.txt \
  -t ${mvp_hub}/file-accounting/flagstat/dsub-inputs/samtools/gs-bina-flagstat-missing-${date_stamp}.tsv \
  -o gs://${mvp_bucket}/dsub/flagstat/samtools/objects \
  -s alignments.bam.flagstat.tsv
```

#### Run dsub task
```
dsub \
  --zones ${mvp_region} \
  --project ${mvp_project} \
  --logging gs://${mvp_bucket}/dsub/flagstat/samtools/logs/${date_stamp} \
  --image gcr.io/gbsc-gcp-project-mvp/samtools \
  --disk-size 1000 \
  --command 'samtools flagstat ${INPUT} > ${OUTPUT}' \
  --tasks ${mvp_hub}/file-accounting/flagstat/dsub-inputs/samtools/gs-bina-flagstat-missing-${date_stamp}.tsv \
  #--dry-run
```

#### Watch dsub task
```
watch -n15 "${dstat_command}"
```

#### Get new list of completed results files
```
mkdir ${mvp_hub}/file-accounting/flagstat/${date_stamp}
cd ${mvp_hub}/file-accounting/flagstat/${date_stamp}
gsutil ls gs://${mvp_bucket}/dsub/flagstat/samtools/objects/*alignments.bam.flagstat.tsv \
  > gs-bina-flagstat-tsv-${date_stamp}.txt
```

## 2. Text-to-table

#### Get list of flagstat text & table files
```
cd ${mvp_hub}/file-accounting/flagstat/${date_stamp}
gsutil ls gs://${mvp_bucket}/dsub/flagstat/samtools/objects/*alignments.bam.flagstat.tsv \
  > gs-bina-flagstat-tsv-${date_stamp}.txt
wc -l gs-bina-flagstat-tsv-${date_stamp}.txt
gsutil ls gs://${mvp_bucket}/dsub/flagstat/text-to-table/objects/*alignments.bam.flagstat.tsv.csv \
  > gs-bina-flagstat-csv-${date_stamp}.txt
```

#### Convert file lists to sample lists and get missing samples
```
cut -d'/' -f8 gs-bina-flagstat-csv-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-flagstat-csv-sample-ids-${date_stamp}.txt
cut -d'/' -f8 gs-bina-flagstat-tsv-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-flagstat-tsv-sample-ids-${date_stamp}.txt
diff \
  --new-line-format="" \
  --unchanged-line-format "" \
  <(sort gs-bina-flagstat-tsv-sample-ids-${date_stamp}.txt) \
  <(sort gs-bina-flagstat-csv-sample-ids-${date_stamp}.txt) \
  > gs-bina-flagstat-csv-sample-ids-missing-${date_stamp}.txt
grep \
  -F \
  -f gs-bina-flagstat-csv-sample-ids-missing-${date_stamp}.txt \
  gs-bina-flagstat-tsv-${date_stamp}.txt \
  > gs-bina-flagstat-csv-missing-${date_stamp}.txt
```

#### Convert file list to dsub TSV files
```
${mvp_hub}/bin/make-batch-tsv-from-input-file.py \
  -i ${mvp_hub}/file-accounting/flagstat/${date_stamp}/gs-bina-flagstat-csv-missing-${date_stamp}.txt \
  -t ${mvp_hub}/file-accounting/flagstat/dsub-inputs/text-to-table/gs-bina-flagstat-csv-missing-${date_stamp}.tsv \
  -o gs://${mvp_bucket}/dsub/flagstat/text-to-table/objects \
  -s csv \
  -c flagstat \
  -e flagstat-${date_stamp}
```

#### Run dsub task
```
dsub \
  --zones ${mvp_region} \
  --project ${mvp_project} \
  --logging gs://${mvp_bucket}/dsub/flagstat/text-to-table/logs/${date_stamp} \
  --image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
  --command 'text2table -s ${SCHEMA} -o ${OUTPUT} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT}' \
  --tasks ${mvp_hub}/file-accounting/flagstat/dsub-inputs/text-to-table/gs-bina-flagstat-csv-missing-${date_stamp}.tsv \
  #--dry-run
```

#### Get new list of completed results files
```
cd ${mvp_hub}/file-accounting/flagstat/${date_stamp}
gsutil ls gs://${mvp_bucket}/dsub/flagstat/text-to-table/objects/*alignments.bam.flagstat.tsv.csv \
  > gs-bina-flagstat-csv-${date_stamp}.txt
```

## 3. Concat

#### Run dsub task
```
dsub \
  --zones ${mvp_region} \
  --project ${mvp_project} \
  --logging gs://${mvp_bucket}/dsub/flagstat/concat/logs/${date_stamp} \
  --image gcr.io/gbsc-gcp-project-mvp/text-to-table:0.2.0 \
  --disk-size 100 \
  --vars-include-wildcards \
  --input INPUT_FILES=gs://${mvp_bucket}/dsub/flagstat/text-to-table/objects/*alignments.bam.flagstat.tsv.csv \
  --output CONCAT_FILE=gs://${mvp_bucket}/dsub/flagstat/concat/objects/concat_alignments.bam.flagstat.tsv.csv \
  --command 'cat ${INPUT_FILES} > ${CONCAT_FILE}' \
  #--dry-run
```

