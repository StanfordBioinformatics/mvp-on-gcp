#!/bin/bash 

FILEPATH_NO_EXT="${INPUT%.*}"
FILEDIR="$(dirname ${INPUT})"
OUTPUT_DIR="$(dirname ${OUTPUT})"

echo ${INPUT}
echo ${OUTPUT}
echo ${FILEPATH_NO_EXT}
echo ${OUTPUT_DIR}

tar -xvf ${INPUT} -C ${OUTPUT_DIR}
