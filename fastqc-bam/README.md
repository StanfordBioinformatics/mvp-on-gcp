# fastqc-bam

## What do I need to do?
- Get list of all variants.gvcf.gz files: IN-PROGRESS
- Get list of all samples?
- Get list of all rtg_vcfstats.txt files
- Convert to sample lists
- Find difference between lists
- Use make-batch-tsv-from-input-sample.py to generate dsub batch input

## Code
### FastQC

#### Get list of bam files (& sample IDs) on GCS

```
$ gsutil ls gs://${mvp_bucket}/data/bina-deliverables/*/*/Recalibration/alignments.bam > gs-bina-bam-${date_stamp}.txt
$ cut -d'/' -f6 gs-bina-bam-${date_stamp}.txt > gs-bina-bam-sample-ids-${date_stamp}.txt
```

#### Get list of bam files that need fastqc

```
$ gsutil ls gs://${mvp_bucket}/dsub/fastqc-bam/fastqc/objects/*_alignments.bam.fastqc_data.txt > gs-bina-fastqc-data-${date_stamp}.txt
$ cut -d '/' -f8 gs-bina-fastqc-data-${date_stamp}.txt | cut -d'_' -f1 > gs-bina-fastqc-data-sample-ids-${date_stamp}.txt
$ diff --new-line-format="" --unchanged-line-format "" \
<(sort gs-bina-bam-sample-ids-${date_stamp}.txt) \
<(sort gs-bina-fastqc-data-sample-ids-${date_stamp}.txt) \
> gs-bina-fastqc-data-missing-sample-ids-${date_stamp}.txt
$ grep -F -f gs-bina-fastqc-data-missing-sample-ids-${date_stamp}.txt gs-bina-bam-${date_stamp}.txt > gs-bina-fastqc-data-missing-${date_stamp}.txt
```

#### Create dsub TSV input file

```
$ ./make-batch-tsv-from-input-sample.py -i file_accounting/fastqc-bam/gs-bina-fastqc-data-missing-${date_stamp}.txt -t inputs/process/fastqc-bam/fastqc/gs-bina-fastqc-data-missing-${date_stamp}.tsv -o gs://${mvp_bucket}/dsub/fastqc-bam/fastqc/objects -s alignments.bam.fastqc_data.txt
```

#### Run dsub tasks

```
dsub \
--zones ${mvp_region} \
--project ${mvp_project} \
--logging gs://${mvp_bucket}/dsub/fastqc-bam/fastqc/logs/20${date_stamp} \
--image gcr.io/${mvp_project}/fastqc:1.01 \
--disk-size 500 \
--script fastqc.sh \
--tasks ${mvp_hub}/fastqc-bam/dsub-inputs/fastqc/gs-bina-fastqc-data-missing-${date_stamp}.tsv \
--dry-run
```

### Text-to-table

#### Source mvp environment file
```
$ source mvp-profile.sh
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
$ diff \
--new-line-format="" \
--unchanged-line-format "" \
<(sort gs-bina-fastqc-bam-txt-sample-ids-${date_stamp}.txt) \
<(sort gs-bina-fastqc-bam-csv-sample-ids-${date_stamp}.txt) \
> gs-bina-fastqc-bam-csv-sample-ids-missing-${date_stamp}.txt
$ grep -F -f gs-bina-fastqc-bam-csv-sample-ids-missing-${date_stamp}.txt gs-bina-fastqc-bam-txt-${date_stamp}.txt > gs-bina-fastqc-bam-csv-missing-${date_stamp}.txt
````

#### Convert file list to dsub TSV files
```
$ ${mvp_hub}/bin/make-batch-tsv-from-input-file.py \
-i ${mvp_hub}/fastqc-bam/file-accounting/${date_stamp}/gs-bina-fastqc-bam-csv-missing-${date_stamp}.txt \
-t ${mvp_hub}/fastqc-bam/dsub-inputs/text-to-table/gs-bina-fastqc-bam-csv-missing-${date_stamp}.tsv \
-o gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects \
-s csv \
-c fastqc \
-e fastqc-bam-${date_stamp}
```

#### Run dsub task
```
$ ${mvp_hub}/fastqc-bam/dsub-scripts/run-fastqc-bam-t2t.sh
```

#### Get new list of completed results files
```
$ cd ${mvp_hub}/fastqc-bam/file-accounting/${date_stamp}
$ gsutil ls gs://${mvp_bucket}/dsub/fastqc-bam/text-to-table/objects/*alignments.bam.fastqc_data.txt.csv > gs-bina-fastqc-bam-csv-${date_stamp}.txt
```

### Concat

#### Run dsub task
```
$ ${mvp_hub}/fastqc-bam/dsub-scripts/run-fastqc-bam-concat.sh
```
