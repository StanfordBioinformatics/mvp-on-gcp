#!/bin/bash
#set -o nounset
#set -o errexit

SAMPLE_FILE=$1
MAX_JOBS=1500
LOGFILE="accountant-jobs-170719.txt"

#####
# Check whether sample directories exist & do decryption
# To-do:
#   - convert custom decrypt script to dsub command script
#####

# Get list of all tar.pgp files
#echo "##### Getting list of tar.pgp files"
#TAR_PGPS=$(gsutil -m ls gs://gbsc-gcp-project-mvp-received-from-bina/446831994/*tar.pgp)

counter=0
[ ! -f ${SAMPLE_FILE} ] && { echo "${SAMPLE_FILE} file not found"; exit 99; }
while IFS=',' read sample; do
    TAR_PGPS=$(gsutil -m ls gs://gbsc-gcp-project-mvp-received-from-bina/${sample}/*tar.pgp)
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
        DIR=$(gsutil ls -d gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/"${BASENAME}" 2>&1)

        #echo "##### Archive: ${TAR}"
        echo "# Sample plus directory name: ${BASENAME}"

        ## This still doesn't work.
        if [ "${DIR}" = "CommandException: One or more URLs matched no objects." ]; then
        #if [ -z ${DIR+x} ]; then
            echo "# No directory found for ${TAR}."
            echo "~~~ Running decryption."
            #echo "## gsutil result: ${DIR}"
            ## Run dsub decryption
            
            dsub \
            --zones "us-central1-*" \
            --project gbsc-gcp-project-mvp \
            --logging gs://gbsc-gcp-project-mvp-phase-2-data/dsub/decrypt/logs \
            --image gcr.io/gbsc-gcp-project-mvp/gs_decrypt_dflow \
            --disk-size 800 \
            --script command_scripts/decrypt.sh \
            --input TARFILE=${TAR} \
            --input PASSPHRASE=gs://gbsc-gcp-project-mvp-va_aaa/misc/keys/passphrase.txt \
            --input ASCPAIR=gs://gbsc-gcp-project-mvp-va_aaa/misc/keys/pair.asc \
            --output-recursive OUTPUTPATH=gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/${SAMPLE} \
            #--dry-run

    	echo "Running decryption on ${TAR}" >> ${LOGFILE}

            counter=$((counter+1))
        else
            echo "# Found directory ${DIR}."
            echo "@@@ Skipping."
        fi
    done
done < ${SAMPLE_FILE}


