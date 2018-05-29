#!/bin/bash
set -o nounset
set -o errexit

# Parse command line arguments
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -t|--tsv)
    tsv_file="$2"
    shift # past argument
    ;;
    -d|--disksize)
    disk_size="$2"
    shift # past argument
    ;;
esac
shift
done

# Command line variables
printf '\n%s\n' "##--- Command-line options"
printf '%s\n'   "# tsv_file: ${tsv_file}"
printf '%s\n'   "# disk_size: ${disk_size}"
printf '%s\n\n' "##---"

# Environment variables
printf "##--- General environment variables\n"
printf "# date_stamp:  ${date_stamp}\n"
printf "# mvp_hub:     ${mvp_hub}\n"
printf "# mvp_project: ${mvp_project}\n"
printf "# mvp_bucket:  ${mvp_bucket}\n"
printf "# mvp_zone:    ${mvp_zone}\n"
printf "##---\n\n"

# Call dsub
echo "# Calling dsub"
dsub_out=$((dsub \
--zones ${mvp_zone} \
--project ${mvp_project} \
--logging ${integrity_logs_root} \
--image ubuntu:16.10 \
--disk-size ${disk_size} \
--script ${mvp_hub}/decrypt/scripts/integrity-check.sh \
--tasks ${tsv_file}) \
--dry-run
2>&1)

printf '%s\n' "${dsub_out}"
