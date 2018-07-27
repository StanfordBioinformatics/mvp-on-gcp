#!/bin/bash 

FILEPATH_NO_EXT="${INPUT%.*}"
FILEDIR="$(dirname ${INPUT})"
INPUT_BASE="$(basename ${INPUT})"
INPUT_NO_EXT="${INPUT_BASE%.*}"
OUTPUT_DIR="$(dirname ${OUTPUT})"

echo ${INPUT}
echo ${OUTPUT}
#echo ${FILEPATH_NO_EXT}
echo ${OUTPUT_DIR}
echo ${INPUT_BASE}
echo ${SAMPLE_ID}
#echo ${FILEDIR}

fastqc ${INPUT} --outdir=${OUTPUT_DIR}
#unzip -d ${OUTPUT_DIR}/${INPUT_NO_EXT}_fastqc.zip
#mv ${OUTPUT_DIR}/${INPUT_NO_EXT}_fastqc/fastqc_data.txt ${OUTPUT_DIR}/${SAMPLE_ID}_fastqc_data.txt
#mv ${FILEPATH_NO_EXT}_fastqc/fastqc_data.txt ${OUTPUT}
#OUTPUT=${INPUT}.fastqc_data.txt
