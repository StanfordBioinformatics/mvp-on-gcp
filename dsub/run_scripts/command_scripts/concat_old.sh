IFS=',' read -ra FILES <<< ${INPUT_FILES}
for file in "${FILES[@]}"; do
    cat "${file}" >> "${CONCAT_FILE}";
done
