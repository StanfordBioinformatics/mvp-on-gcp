dsub \
   --provider local \
   --logging /tmp/dsub-test/logging/ \
   --output OUT=/tmp/dsub-test/output/out.txt \
   --command 'echo "Hello World" > "${OUT}"' \
   --wait
