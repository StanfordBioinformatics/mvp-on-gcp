#!/bin/bash

## Inputs
#$INPUT_PATH
#$REF_CSV

## Outputs
#$ACTUAL_SIZES
#$SIZE_MISSING
#$SIZE_PASS
#$SIZE_FAIL
#$SHA1_MISSING
#$SHA1_PASS
#$SHA1_FAIL


sample=$(basename ${REF_CSV} | cut -d'.' -f1)

echo "Comparing reported vs. actual file sizes"
[ ! -f ${REF_CSV} ] && { echo "${REF_CSV} file not found"; exit 99; }
while IFS=',' read local_path report_size; do
    # Get object information from report
    echo "File path: ${local_path}"
    full_path="${INPUT_PATH}/${local_path}"

    ls_result=$(ls -l ${full_path})
    real_size=$(echo ${ls_result} | cut -d' ' -f 5)
    real_sum=$(sha1sum ${full_path} | cut -d' ' -f1)
    report_sum=$(head -n1 ${full_path}.sha1 | cut -d' ' -f1)

    echo "Report size: ${report_size}"
    echo "Real size: ${real_size}"
    echo "Report sha1: ${report_sum}"
    echo "Real sum: ${real_sum}"

    # Report file size result
    if [ -z "${real_size}" ]; then
        echo "Missing file: ${sample},${local_path},NA,NA,-1"
        echo "${sample},${local_path},NA,NA,-1" >> ${SIZE_MISSING}
        real_size=0
    elif [ "${real_size}" -eq "${report_size}" ]; then
        echo "${sample},${local_path},${real_size},${report_size},1" >> ${SIZE_PASS}
    else
        echo "${sample},${local_path},${real_size},${report_size},0" >> ${SIZE_FAIL}
    fi

    # Report file checksum result
    if [[ -z "${real_sum}" ]]; then
        echo "Missing file: ${sample},${local_path},NA,NA,-1"
        echo "${sample},${local_path},NA,NA,-1" >> ${SHA1_MISSING}
        real_size=0
    elif [[ "$real_size" == "$report_size" ]]; then
        echo "${sample},${local_path},${real_sum},${report_sum},1" >> ${SHA1_PASS}
    else
        echo "${sample},${local_path},${real_sum},${report_sum} 0" >> ${SHA1_FAIL}
    fi
done < ${REF_CSV}