#!/bin/bash

# Compare reported/actual file sizes
REPORT_SIZES=$1
ACTUAL_SIZES=$2
OUTPUT_FILE=$3

# For each reported file + size, get actual size
#IFS=,
[ ! -f ${REPORT_SIZES} ] && { echo "${REPORT_SIZES} file not found"; exit 99; }
while IFS=',' read FILEPATH REPORT_SIZE
do
    # Get object information from report
    echo ${FILEPATH} ${REPORT_SIZE}
    REPORT_SIZE="$(echo -e "${REPORT_SIZE}" | tr -d '[:space:]')"
    #IFS='.' read -a dot_array <<< "${FILEPATH}"
    #SAMPLE="${dot_array[0]}"
    #IFS=':' read -a colon_array <<< "${dot_array[1]}"
    #FILE_PATH="${colon_array[1]}"
    SAMPLE=$(echo ${FILEPATH} | cut -d'.' -f1)
    FILE_PATH=$(echo ${FILEPATH} | cut -d':' -f2)
    # Get gsutil object information
    echo "TEST: grep ${FILE_PATH} ${ACTUAL_SIZES}"
    GSUTIL_OBJECT=$(grep "$FILE_PATH" "$ACTUAL_SIZES")
    GSUTIL_SIZE=`echo "${GSUTIL_OBJECT}" | cut -d' ' -f 1`
    GSUTIL_SIZE="$(echo -e "${GSUTIL_SIZE}" | tr -d '[:space:]')"
    echo "${GSUTIL_SIZE} ${REPORT_SIZE}"
    if [ -z "${GSUTIL_SIZE}" ]; then
        echo "${SAMPLE},${FILE_PATH},NA,NA,-1"
        echo "${SAMPLE},${FILE_PATH},NA,NA,-1" >> ${OUTPUT_FILE}-missing.csv
        GSUTIL_SIZE=0
    elif [ "${GSUTIL_SIZE}" -eq "${REPORT_SIZE}" ]; then
        echo "${SAMPLE},${FILE_PATH},${GSUTIL_SIZE},${REPORT_SIZE},1" >> ${OUTPUT_FILE}-pass.csv
    else
        echo "${SAMPLE},${FILE_PATH},${GSUTIL_SIZE},${REPORT_SIZE},0" >> ${OUTPUT_FILE}-fail.csv
    fi
done < ${REPORT_SIZES}

