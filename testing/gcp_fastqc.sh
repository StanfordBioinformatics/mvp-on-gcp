#!/bin/bash

## gcp run test
dsub \
  --project gbsc-gcp-project-mvp \
  --zones "us-*" \
  --logging gs://gbsc-gcp-project-mvp-group/for-jina/dsub/publicfiletest/logs/ \
  --image gcr.io/${mvp_project}/fastqc:1.01 \
  --disk-size 500 \
  --script /Users/jinasong/Work/MVP/mvp-on-gcp/dsub_test/fastqc_test.sh \
  --tasks /Users/jinasong/Work/MVP/mvp-on-gcp/dsub_test/fastqc_test_one.tsv 

## gcp run test
#dsub \
#  --project gbsc-gcp-project-mvp \
#  --zones "us-*" \
#  --logging gs://gbsc-gcp-project-mvp-group/for-jina/dsub/publicfiletest/logs/ \
#  --output OUT=gs://gbsc-gcp-project-mvp-group/for-jina/dsub/publicfiletest/hello.txt \
#  --command 'echo "Hello World" > "${OUT}"' \
#  --wait
