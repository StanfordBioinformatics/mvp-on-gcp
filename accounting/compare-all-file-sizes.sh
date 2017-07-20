#!/bin/bash

GSUTIL_DIR="gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables"

REF_DIR=$1
ACTUAL_DIR=$2
RESULT_FILE=$3

# For csv file in accounting directory
REF_CSVS=$(find "${REF_DIR}" -name '*.csv')
for ref_csv in ${REF_CSVS}; do 
    sample=$(basename ${ref_csv} | cut -d'.' -f1)
    echo "Accounting for ${sample} files."
    
    # Do an ls -l on the corresponding sample dir & store in file
    echo "Looking up files on Google Storage."
    #gsutil ls -l -r ${GSUTIL_DIR}/${sample} > ${ACTUAL_DIR}/${sample}.txt

    # For each line in reference file look up corresponding line in actual
    echo "Comparing reported vs. actual file sizes"
    [ ! -f ${ref_csv} ] && { echo "${ref_csv} file not found"; exit 99; }
    while IFS=',' read full_path reported_size
    do
        # Get object information from report
        echo ${full_path} ${reported_size}
        reported_size="$(echo -e "${reported_size}" | tr -d '[:space:]')"
        file_path=$(echo ${full_path} | cut -d':' -f2)

        # Get gsutil object information
        echo "TEST: grep ${file_path} ${ACTUAL_DIR}/${sample}.txt"
        gsutil_object=$(grep "$file_path"$ "${ACTUAL_DIR}/${sample}.txt")
        echo "GSUTIL OBJECT: ${gsutil_object}"
        read -ra gsutil_array -d '' <<< "$gsutil_object"
        gsutil_size=${gsutil_array[0]}
        #gsutil_size=`echo "${gsutil_object}" | cut -f 1`
        #gsutil_size="$(echo -e "${gsutil_size}" | tr -d '[:space:]')"
        echo "GSUTIL SIZE: ${gsutil_size}"
        echo "${gsutil_size} ${reported_size}"
        if [ -z "${gsutil_size}" ]; then
            echo "MISSING: ${sample},${file_path},NA,NA,-1"
            echo "${sample},${file_path},NA,NA,-1" >> ${RESULT_FILE}-missing.csv
            gsutil_size=0
        elif [ "${gsutil_size}" -eq "${reported_size}" ]; then
            echo "${sample},${file_path},${gsutil_size},${reported_size},1" >> ${RESULT_FILE}-pass.csv
        else
            echo "${sample},${file_path},${gsutil_size},${reported_size},0" >> ${RESULT_FILE}-fail.csv
        fi
    done < ${ref_csv}
    exit
done
# Report results