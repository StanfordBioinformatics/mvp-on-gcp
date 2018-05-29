#!/bin/bash
#set -o nounset
#set -o errexit

# Parse command line arguments
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -d|--disksize)
    disk_size="$2"
    shift # past argument
    ;;
esac
shift
done

# Command line variables
printf "##--- Command-line options\n"
printf "# disk_size: ${disk_size}\n"
printf "##---\n\n"

# Environment variables
printf "##--- General environment variables\n"
printf "# date_stamp:  ${date_stamp}\n"
printf "# mvp_hub:     ${mvp_hub}\n"
printf "# mvp_project: ${mvp_project}\n"
printf "# mvp_bucket:  ${mvp_bucket}\n"
printf "# mvp_zone:    ${mvp_zone}\n"
printf "##---\n\n"

printf "##--- Decryption-specific variables\n"
printf "# dsub_max_jobs:       ${dsub_max_jobs}\n"
printf "# mvp_tar_pgp_path:    ${mvp_tar_pgp_path}\n"
printf "# mvp_samples_path:    ${mvp_samples_path}\n"
printf "# mvp_decrypt_pass:    ${mvp_decrypt_pass}\n"
printf "# mvp_decrypt_ascpair: ${mvp_decrypt_ascpair}\n"
printf "##---\n\n"

logfile="accountant-jobs-${date_stamp}.txt"

# Get list of all tar.pgp files
printf "##--- Getting list of tar.pgp files\n"
tar_pgps=$(gsutil -m ls gs://${mvp_tar_pgp_path}/*/*tar.pgp)

counter=0
for tar in ${tar_pgps}; do
    printf "# Counter: ${counter}\n"
    printf "##--- Archive: ${tar}\n"
    if [ "$counter" -gt "${dsub_max_jobs}" ]; then
        printf "##---Maximum number of jobs (${dsub_max_jobs}) reached. Exiting.\n"
        exit
    fi
    base_dir=$(printf ${tar} | cut -d'/' -f4,5)
    basename=${base_dir%.tar.pgp}
    sample=$(printf ${tar} | cut -d'/' -f4)
    
    # Need to change pattern for MetaSV files
    if [[ "$basename" == *.MetaSV ]]; then
        printf "# Accounting for MetaSV format\n"
        basename="${sample}/MetaSV"
    fi
    
    printf "# Checking for existing directory.\n"
    dir=$(gsutil ls -d gs://${mvp_samples_path}/"${basename}" 2>&1)


    printf "# Sample plus directory name: ${basename}\n"
    if [ "${dir}" = "CommandException: One or more URLs matched no objects." ]; then
        printf "# No directory found for ${tar}.\n"
        printf "##~~~ Running decryption.\n"

        ## Run dsub decryption
        dsub \
        --zones ${mvp_zone} \
        --project ${mvp_project} \
        --logging gs://${mvp_bucket}/dsub/decrypt/logs/${date_stamp} \
        --image gcr.io/${mvp_project}/gs_decrypt_dflow \
        --disk-size ${disk_size} \
        --script ${mvp_hub}/decrypt/dsub-scripts/decrypt.sh \
        --input TARFILE=${tar} \
        --input PASSPHRASE=gs://${mvp_decrypt_pass} \
        --input ASCPAIR=gs://${mvp_decrypt_ascpair} \
        --output-recursive OUTPUTPATH=gs://${mvp_samples_path}/${sample} \
        --dry-run

	printf "Running decryption on ${tar}\n" >> ${logfile}
        counter=$((counter+1))
    else
        printf "# Found directory ${dir}.\n"
        printf "##--- Skipping.\n\n"
    fi
done


