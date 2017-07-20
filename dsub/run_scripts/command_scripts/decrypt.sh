#!/bin/bash

## OLD
#mkdir -p /mnt/data/output
#decrypt_dflow_batch.sh ${TARFILE} ${PASSPHRASE} ${ASCPAIR} ${OUTPUTPATH}

#UNENCRYPTED=$(${TARFILE%.tar.pgp})
NOEXT=${TARFILE%.tar.pgp}
UNENCRYPTED=${NOEXT##*/}

# Decrypt
echo "Importing asc file into gpg"
gpg --import ${ASCPAIR}

# Decrypt
echo "Decrypting ${encrypted_file} using gpg"
gpg \
--batch \
--yes \
--passphrase-file ${PASSPHRASE} \
--output ${NOEXT}.tar \
--decrypt ${TARFILE}

# Unpack
echo "Unpacking tar file unencrypted.tar"
#tar -xvf /mnt/datadisk/input/unencrypted.tar -C ${OUTPUTPATH}
tar -xvf ${NOEXT}.tar -C ${OUTPUTPATH}
