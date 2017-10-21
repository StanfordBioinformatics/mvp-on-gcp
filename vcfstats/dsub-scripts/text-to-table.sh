for INPUT_FILE in "$(ls "${INPUT_FILES}"); do
	INPUT_FILE_NAME="$(basename "${INPUT_FILE}")"
	SAMPLE_ID="${INPUT_FILE_NAME%%_*}
	text2table -s ${SCHEMA} -v series=${SERIES},sample=${SAMPLE_ID} ${INPUT_FILE} >> ${CONCAT_FILE}
done	
