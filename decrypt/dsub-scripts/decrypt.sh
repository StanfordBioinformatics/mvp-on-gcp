#!/bin/bash

NOEXT=${TARFILE%.tar.pgp}
UNENCRYPTED=${NOEXT##*/}

echo "Importing asc file into gpg"
gpg --import ${ASCPAIR}

echo "Decrypting ${encrypted_file} using gpg"
gpg \
--batch \
--yes \
--passphrase-file ${PASSPHRASE} \
--output ${NOEXT}.tar \
--decrypt ${TARFILE}

echo "Unpacking tar file unencrypted.tar"
tar -xvf ${NOEXT}.tar -C ${OUTPUTPATH}
