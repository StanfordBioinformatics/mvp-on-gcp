dsub \
  --project gbsc-gcp-lab-gbsc \
  --zones "us-west1-*" \
  --logging gs://gbsc-gcp-lab-gbsc-group/logging/ \
  --output OUT=gs://gbsc-gcp-lab-gbsc-group/output/out.txt \
  --command 'echo "Hello World" > "${OUT}"' \
  --wait
