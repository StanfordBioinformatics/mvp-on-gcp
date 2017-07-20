#!/bin/bash
set -o nounset
set -o errexit

GREG_DIRS=$1

[ ! -f ${GREG_DIRS} ] && { echo "${GREG_DIRS} file not found"; exit 99; }
while IFS=',' read sample
do
	gsutil -m rm -r gs://gbsc-gcp-project-mvp-phase-2-data/data/bina-deliverables/${sample}
#	exit 99
done < ${GREG_DIRS}
