#!/bin/bash

TMP_DIR="flagstat-failed-1/*"
GS_PATH="gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/text-to-table/objects"
GS_BAD_PATH="gs://gbsc-gcp-project-mvp-phase-2-data/dsub/flagstat/text-to-table/failed"

#for TMP_FILE in "$(ls "${TMP_DIR}")"; do
#	echo "${TMP_FILE}";
#done

for TMP_FILE in ${TMP_DIR}
do
	TMP_BASE=$(basename ${TMP_FILE})
	BAD_FILE=${TMP_BASE%_.gstmp}
	echo "tmp base: ${TMP_BASE}\n"
	echo "bad file: ${BAD_FILE}\n"
	gsutil mv ${GS_PATH}/${BAD_FILE} ${GS_BAD_PATH}/
	#echo "gs path: ${GS_PATH}/${BAD_FILE} ${GS_BAD_PATH}\n"
done	
	
