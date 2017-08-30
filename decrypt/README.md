# decrypt

# What do I need to do?
1. Check that there is a corresponding sample directory for every sample tar.pgp file
2. Identify any missing sample directories
3. For each missing sample, run decryption + extraction to generate sample directory
4. Check dirs again to make sure decrypt + extraction was successful
5. For every file in each sample directory:
    1. Calculate sha1 sum and compare to original value
    2. Get file size and compare to original file size
    3. Record any discrepancies
6. For any samples that failed the integrity check (sha1 + filesize)
    1. Delete existing sample directory
    2. Repeat steps 2-6
    
# Files
* **descrypt.sh**: Store environment variables specific to decryption & integrity check tasks.
* **dir-accountant.sh**: Get a list of encrypted tar.pgp archives on a GCS path. 
For each archive, check if there is a directory with the same basename on a different GCS path. 
If no corresponding directory found, launch a dsub job to decrypt & extract that tar.pgp archive.
* **call-integrity-check.sh**: 
    
# Code
## 1. Decrypt + Extract

## 2. Integrity Check
