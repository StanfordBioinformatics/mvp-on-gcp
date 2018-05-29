# General use dynamic variables
export mvp_hub="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export date_stamp=$(date "+%Y%m%d")

# Path to dsub virtual env activator - can we include this environment in mvp-hub ?
export dsub_venv="/Users/jinasong/Work/MVP/dsub/dsub_libs/bin/activate/dsub-libs/bin/activate"

# Environment metadata for running MVP dsub jobs
export mvp_project="gbsc-gcp-project-mvp"
export mvp_orig_bucket="gbsc-gcp-project-mvp-phase-2-data"
export mvp_bucket="gbsc-gcp-project-mvp-group/for-jina"
export mvp_zone="us-*"

# Decrypt & extraction variables
export TAR_PGP_PATH=""
export SAMPLES_PATH=""
export MAX_JOBS=500
export DECRYPT_PASS=""
export DECRYPT_ASCPAIR=""

