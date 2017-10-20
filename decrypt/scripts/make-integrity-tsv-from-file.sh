#!/bin/bash
set -o nounset
set -o errexit

# Parse command line arguments
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -s|--samples)
    samples_list="$2"
    shift # past argument
    ;;
esac
shift
done

# Command line variables
printf '\n%s\n' "##--- Command-line options"
printf '%s\n' "# samples_list: ${samples_list}"
printf '%s\n\n' "##---"

# Environment variables
printf '%s\n' "##--- General environment variables"
printf '%s\n' "# date_stamp:  ${date_stamp}"
printf '%s\n' "# mvp_hub:     ${mvp_hub}"
printf '%s\n' "# mvp_project: ${mvp_project}"
printf '%s\n' "# mvp_bucket:  ${mvp_bucket}"
printf '%s\n' "# mvp_zone:    ${mvp_zone}"
printf '%s\n\n' "##---"

printf '%s\n' "##--- Decryption-specific variables"
printf '%s\n' "# samples_root: ${samples_root}"
printf '%s\n\n' "##---"

printf '%s\n' "##--- Integrity-specific variables"
printf '%s\n' "# reported_sizes_root: ${reported_sizes_root}"
printf '%s\n' "# integrity_output_roots: ${integrity_output_root}"
printf '%s\n\n' "##---"

# Create tsv file & add header
tsv_file="${mvp_hub}/decrypt/file-accounting/${date_stamp}/${date_stamp}-integrity-check.tsv"
# Inputs
printf '%s\t' "--input-recursive INPUT_PATH" >> ${tsv_file}
printf '%s\t' "--input REF_CSV" >> ${tsv_file}
# Outputs
printf '%s\t' "--output ACTUAL_SIZES" >> ${tsv_file}
printf '%s\t' "--output SIZE_MISSING" >> ${tsv_file}
printf '%s\t' "--output SIZE_PASS" >> ${tsv_file}
printf '%s\t' "--output SIZE_FAIL" >> ${tsv_file}
printf '%s\t' "--output SHA1_MISSING" >> ${tsv_file}
printf '%s\t' "--output SHA1_PASS" >> ${tsv_file}
printf '%s\n' "--output SHA1_FAIL" >> ${tsv_file}

# For each sample, write arguments to file tsv file
printf '%s\n' "# Generating TSV entry for each sample"
while IFS='' read -r sample; do
        sample_path=${samples_root}/${sample}
        ref_csv="${reported_sizes_root}/${sample}.csv"
        actual_sizes="${integrity_output_root}/check-sizes/${sample}-sizes-actual.csv"
        size_missing="${integrity_output_root}/check-sizes/${sample}-sizes-missing.csv"
        size_pass="${integrity_output_root}/check-sizes/${sample}-sizes-pass.csv"
        size_fail="${integrity_output_root}/check-sizes/${sample}-sizes-fail.csv"
        sha1_missing="${integrity_output_root}/check-sha1/${sample}-sha1-missing.csv"
        sha1_pass="${integrity_output_root}/check-sha1/${sample}-sha1-pass.csv"
        sha1_fail="${integrity_output_root}/check-sha1/${sample}-sha1-fail.csv"
        
        printf '%s\t' "${sample_path}" >> ${tsv_file}
        printf '%s\t' "${ref_csv}" >> ${tsv_file}
        printf '%s\t' "${actual_sizes}" >> ${tsv_file}
        printf '%s\t' "${size_missing}" >> ${tsv_file}
        printf '%s\t' "${size_pass}" >> ${tsv_file}
        printf '%s\t' "${size_fail}" >> ${tsv_file}
        printf '%s\t' "${sha1_missing}" >> ${tsv_file}
        printf '%s\t' "${sha1_pass}" >> ${tsv_file}
        printf '%s\n' "${sha1_fail}" >> ${tsv_file}
done < "${samples_list}"
