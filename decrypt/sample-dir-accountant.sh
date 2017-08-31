#!/bin/bash
#set -o nounset
#set -o errexit

# Parse command line arguments
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -s|--sample)
    SAMPLE="$2"
    shift # past argument
    ;;
    -d|--disksize)
    DISK_SIZE="$2"
    shift # past argument
    ;;
esac
shift
done

# Command line variables
echo "##### Command-line variables"
echo "# SAMPLE: ${SAMPLE}"
echo "# DISK_SIZE: ${DISK_SIZE}"
echo "#####"

# Echo environment variables
echo "##### Environment variables"
echo "# MAX_JOBS: ${MAX_JOBS}"
echo "# TAR_PGP_PATH: ${TAR_PGP_PATH}"
echo "# SAMPLES_PATH: ${SAMPLES_PATH}"
echo "# DATE_STAMP: ${DATE_STAMP}"
echo "# DECRYPT_PASS: ${DECRYPT_PASS}"
echo "# DECRYPT_ASCPAIR: ${DECRYPT_ASCPAIR}"
echo "#####"

LOGFILE="accountant-jobs-${DATE_STAMP}.txt"

# Get list of all tar.pgp files
echo "##### Getting list of tar.pgp files"
TAR_PGPS=$(gsutil -m ls gs://${TAR_PGP_PATH}/${SAMPLE}/*tar.pgp)

counter=0
for TAR in ${TAR_PGPS}; do
    echo "# Counter: ${counter}"
    echo "##### Archive: ${TAR}"
    if [ "$counter" -gt "${MAX_JOBS}" ]; then
        echo "Maximum number of jobs (${MAX_JOBS}) reached. Exiting."
        exit
    fi
    BASE_DIR=$(echo ${TAR} | cut -d'/' -f4,5)
    BASENAME=${BASE_DIR%.tar.pgp}
    SAMPLE=$(echo ${TAR} | cut -d'/' -f4)
    
    # Need to change pattern for MetaSV files
    if [[ "$BASENAME" == *.MetaSV ]]; then
        echo "# Accounting for MetaSV format"
        BASENAME="${SAMPLE}/MetaSV"
    fi
    
    echo "# Checking for existing directory."
    DIR=$(gsutil ls -d gs://${SAMPLE_PATH}/"${BASENAME}" 2>&1)


    echo "# Sample plus directory name: ${BASENAME}"
    if [ "${DIR}" = "CommandException: One or more URLs matched no objects." ]; then
        echo "# No directory found for ${TAR}."
        echo "~~~ Running decryption."

        ## Run dsub decryption
        dsub \
        --zones ${MVP_ZONE} \
        --project ${MVP_PROJECT} \
        --logging gs://${MVP_BUCKET}/dsub/decrypt/logs/${DATE_STAMP} \
        --image gcr.io/${MVP_PROJECT}/gs_decrypt_dflow \
        --disk-size ${DISK_SIZE} \
        --script decrypt.sh \
        --input TARFILE=${TAR} \
        --input PASSPHRASE=gs://${DECRYPT_PASS} \
        --input ASCPAIR=gs://${DECRYPT_ASCPAIR} \
        --output-recursive OUTPUTPATH=gs://${SAMPLES_PATH}/${SAMPLE} \
        #--dry-run

	echo "Running decryption on ${TAR}" >> ${LOGFILE}
        counter=$((counter+1))
    else
        echo "# Found directory ${DIR}."
        echo "@@@ Skipping."
    fi
done


