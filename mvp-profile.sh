# General use dynamic variables
export mvp_hub="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export date_stamp=$(date "+%Y%m%d")

# Path to dsub virtual env activator - can we include this environment in mvp-hub ?
export dsub_venv="/Users/jinasong/Work/MVP/dsub/dsub_libs/bin/activate/dsub-libs/bin/activate"

# Environment metadata for running MVP dsub jobs
export mvp_project="gbsc-gcp-project-mvp"
export mvp_data_bucket="gbsc-gcp-project-mvp-from-personalis"
export mvp_anal_bucket="gbsc-gcp-project-mvp-from-personalis-qc"
export mvp_test_bucket="gbsc-gcp-project-mvp-group/for-jina"
export mvp_zone="us-*"

# Decrypt & extraction variables
export TAR_PGP_PATH=""
export SAMPLES_PATH=""
export MAX_JOBS=500
export DECRYPT_PASS=""
export DECRYPT_ASCPAIR=""

