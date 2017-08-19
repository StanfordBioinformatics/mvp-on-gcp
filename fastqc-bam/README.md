# fastqc-bam
## What do I need to do?
Get list of all variants.gvcf.gz files: IN-PROGRESS
Get list of all samples?
Get list of all rtg_vcfstats.txt files
Convert to sample lists
Find difference between lists
Use make-batch-tsv-from-input-sample.py to generate dsub batch input
## Code
### FastQC


#### Set date stamp to be used in subsequent steps

```
date_stamp="YYMMDD"
```

#### Get list of bam files (& sample IDs) on GCS

```
$ gsutil ls gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/*/*/Recalibration/alignments.bam > gs-bina-bam-${date_stamp}.txt
$ cut -d'/' -f6 gs-bina-bam-${date_stamp}.txt > gs-bina-bam-sample-ids-${date_stamp}.txt
```

#### Get list of bam files that need fastqc

```
$ gsutil ls gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/fastqc/objects/*_alignments.bam.fastqc_data.txt > gs-bina-fastqc-data-${date_stamp}.txt
$ cut -d '/' -f8 gs-bina-fastqc-data-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-fastqc-data-sample-ids-${date_stamp}.txt
$ diff --new-line-format="" --unchanged-line-format "" \
<(sort gs-bina-bam-sample-ids-${date_stamp}.txt) \
<(sort gs-bina-fastqc-data-sample-ids-${date_stamp}.txt) \
> gs-bina-fastqc-data-missing-sample-ids-${date_stamp}.txt
$ grep -F -f gs-bina-fastqc-data-missing-sample-ids-${date_stamp}.txt gs-bina-bam-${date_stamp}.txt > gs-bina-fastqc-data-missing-${date_stamp}.txt
```

#### Create dsub TSV input file

```
$ ./make-batch-tsv-from-input-sample.py -i file_accounting/fastqc-bam/gs-bina-fastqc-data-missing-${date_stamp}.txt -t inputs/process/fastqc-bam/fastqc/gs-bina-fastqc-data-missing-${date_stamp}.tsv -o gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/fastqc/objects -s alignments.bam.fastqc_data.txt
```

#### Run dsub tasks

```
dsub \
--zones "us-central1-*" \
--project gbsc-gcp-project-mvp \
--logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/fastqc-bam/fastqc/logs/20${date_stamp} \
--image gcr.io/gbsc-gcp-project-mvp/fastqc:1.01 \
--disk-size 500 \
--script command-scripts/fastqc.sh \
--tasks ../inputs/process/fastqc-bam/fastqc/gs-bina-fastqc-data-missing-${date_stamp}.tsv \
```

### Text-to-table

#### Source mvp environment file
```
$ source mvp-on-gcp.sh
```

#### Get list of fastqc text & table files
```
$ mkdir ${mvp_hub}/file_accounting/fastqc-bam/${date_stamp}
$ cd ${mvp_hub}/file_accounting/fastqc-bam/${date_stamp}
$ gsutil ls gs://${mvp_bucket}/dsub/fastqc-bam/fastqc/objects/*alignments.bam.fastqc_data.txt > gs-bina-fastqc-bam-txt-${date_stamp}.txt
$ gsutil ls gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects/*alignments.bam.fastqc_data.txt.csv > gs-bina-fastqc-bam-csv-${date_stamp}.txt
```


#### Convert file lists to sample lists and get missing samples
```
$ cut -d'/' -f8 gs-bina-fastqc-bam-txt-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-fastqc-bam-txt-sample-ids-${date_stamp}.txt
$ cut -d'/' -f8 gs-bina-fastqc-bam-csv-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-fastqc-bam-csv-sample-ids-${date_stamp}.txt
$ diff --new-line-format="" --unchanged-line-format "" <(sort gs-bina-fastqc-bam-txt-sample-ids-${date_stamp}.txt) <(sort gs-bina-fastqc-bam-csv-sample-ids-${date_stamp}.txt) > gs-bina-fastqc-bam-csv-sample-ids-missing-${date_stamp}.txt
$ grep -F -f gs-bina-fastqc-bam-csv-sample-ids-missing-${date_stamp}.txt gs-bina-fastqc-bam-txt-${date_stamp}.txt > gs-bina-fastqc-bam-csv-missing-${date_stamp}.txt
````

#### Convert file list to dsub TSV files
```
$ cd ${mvp_hub}/bin
$ ./make-batch-tsv-from-input-file.py \
-i ${mvp_hub}/file-accounting/fastqc-bam/${date_stamp}/gs-bina-fastqc-bam-csv-missing-${date_stamp}.txt \
-t ${mvp_hub}/file-accounting/fastqc-bam/dsub-inputs/text-to-table/gs-bina-fastqc-bam-csv-missing-${date_stamp}.tsv \
-o gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects \
-s csv \
-c fastqc \
-e fastqc-bam-${date_stamp}
```

#### Run dsub task
```
$ source ${mvp_hub}/dsub/dsub_libs/bin/activate
$ cd ${mvp_hub}/bin
$ ./run-fastqc-bam-t2t.sh
```

#### Get new list of completed results files
```
$ cd ${mvp_hub}/file-accounting/fastqc-bam/${date_stamp}
$ gsutil ls gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects/*alignments.bam.fastqc_data.txt.csv > gs-bina-fastqc-bam-csv-${date_stamp}.txt
```

### Concat

#### Run dsub task
```
$ dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/vcfstats/concat/logs/${date_stamp} \
--image gcr.io/${mvp_project}/text-to-table:0.2.0 \
--disk-size 100 \
--vars-include-wildcards \
--input INPUT_FILES=gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects/*alignments.bam.fastqc_data.txt.csv \
--output CONCAT_FILE=gs://${mvp_bucket}/dsub/fastqc-bam/concat/objects/concat_alignments.bam.fastqc_data.txt.csv \
--command 'cat ${INPUT_FILES} > ${CONCAT_FILE}' \
```
