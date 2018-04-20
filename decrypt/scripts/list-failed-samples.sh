#!/bin/bash
set -o nounset
set -o errexit

# Environment variables
printf '%s\n' "##--- General environment variables"
printf '%s\n' "# date_stamp:  ${date_stamp}"
printf '%s\n\n' "##---"

printf '%s\n' "##--- Decryption-specific variables"
printf '%s\n' "# tar_pgp_root: ${tar_pgp_root}"
printf '%s\n\n' "##---"

printf '%s\n' "##--- Integrity-specific variables"
printf '%s\n' "# integrity_objects_roots: ${integrity_objects_root}"
printf '%s\n' "# integrity_local_root: ${integrity_local_root}"
printf '%s\n\n' "##---"

sha1_results_dir="${integrity_local_root}/sha1-results"
size_results_dir="${integrity_local_root}/size-results"
concat_results_dir="${integrity_local_root}/concat-results"

mkdir -p ${sha1_results_dir}
mkdir -p ${size_results_dir}
mkdir -p ${concat_results_dir}

gsutil -m cp ${integrity_objects_root}/check-sha1/* ${sha1_results_dir}/
gsutil -m cp ${integrity_objects_root}/check-sizes/* ${size_results_dir}/

# Get list of all Bina samples
gsutil -m ls ${tar_pgp_root} | cut -d'/' -f4 \
    > ${concat_results_dir}/all-bina-samples.txt

# Create dummy fail files so that cat cmd doesn't error out
touch ${sha1_results_dir}/dummy-fail.csv
touch ${size_results_dir}/dummy-fail.csv

# Concat all missing/failed result files
cat ${sha1_results_dir}/*-missing.csv \
    ${sha1_results_dir}/*-fail.csv \
    > ${concat_results_dir}/${date_stamp}-sha1-fail-missing.csv
cat ${size_results_dir}/*-missing.csv \
    ${size_results_dir}/*-fail.csv \
    > ${concat_results_dir}/${date_stamp}-sizes-fail-missing.csv

# Use missing sample files to get lists of all samples checked
cut -d',' -f1 ${concat_results_dir}/${date_stamp}-sizes-fail-missing.csv \
    | sort \
    | uniq > ${concat_results_dir}/${date_stamp}-checked-samples.txt

# Concat all missing/failed results
cat ${concat_results_dir}/${date_stamp}-sha1-fail-missing.csv \
    ${concat_results_dir}/${date_stamp}-sizes-fail-missing.csv \
    | grep -v ',file,' \
    > ${concat_results_dir}/${date_stamp}-all-fail-missing.csv

# Remove dummy entries and get unique list of failed samples
grep -v ',file,' ${concat_results_dir}/${date_stamp}-all-fail-missing.csv | \
    cut -d',' -f1 | \
    sort | \
    uniq > ${concat_results_dir}/${date_stamp}-all-fail-missing-samples.txt

cp ${concat_results_dir}/${date_stamp}-all-fail-missing-samples.txt \
    ${concat_results_dir}/latest-all-fail-missing-samples.txt

# Compare all vs checked lists to get samples that missed integrity check
diff \
    --new-line-format="" \
    --unchanged-line-format="" \
    <(sort ${concat_results_dir}/${date_stamp}-all-samples.txt) \
    <(sort ${concat_results_dir}/${date_stamp}-checked-samples.txt) \
    > ${concat_results_dir}/${date_stamp}-unchecked-samples.txt
