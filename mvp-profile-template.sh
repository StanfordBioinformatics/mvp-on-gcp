# General use dynamic variables
export MVP_HUB="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DATE_STAMP=$(date "+%Y%m%d")

# Path to dsub virtual env activator
export DSUB_VENV="${MVP_HUB}/dsub-libs/bin/activate"

# Environment metadata for running MVP dsub jobs
export MVP_PROJECT=""
export MVP_BUCKET=""
export MVP_ZONE="us-central1-*"

# Decrypt & extraction variables
export TAR_PGP_PATH=""
export SAMPLES_PATH=""
export MAX_JOBS=500
export DECRYPT_PASS=""
export DECRYPT_ASCPAIR=""

