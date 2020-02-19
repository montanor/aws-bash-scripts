#!/bin/bash

while [[ "${#}" -gt 0 ]]
do
    echo ${1} | base64 --decode > /tmp/temp
    aws kms decrypt --ciphertext-blob  fileb:///tmp/temp --output text --query Plaintext | base64 --decode
    echo " "
    shift
done
rm -rf /tmp/temp