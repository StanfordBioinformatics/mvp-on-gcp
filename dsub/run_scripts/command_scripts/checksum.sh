INPUT_FILES=$(find "${INPUT_PATH}" -type f ! -iname "*.sha1")
echo "$INPUT_PATH"
echo "wc -l ${INPUT_FILES}"
for INPUT_FILE in ${INPUT_FILES}; do
	echo "INPUT_FILE = ${INPUT_FILE}"
	THIS_SUM=$(sha1sum ${INPUT_FILE} | cut -d" " -f1)
	REPORT_SUM=$(head -n1 ${INPUT_FILE}.sha1 | cut -d" " -f1)
	if [ "$THIS_SUM" = "$REPORT_SUM" ]
	then
		echo "PASS"
		echo "${INPUT_FILE} ${THIS_SUM} ${REPORT_SUM} 1" >> ${PASS_FILES}
	else
		echo "FAIL"
		echo "${INPUT_FILE} ${THIS_SUM} ${REPORT_SUM} 0" >> ${FAIL_FILES}
	fi
done
