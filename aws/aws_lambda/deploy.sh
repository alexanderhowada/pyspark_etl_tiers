#!/bin/bash

set -e

if [ "$#" -eq 0 ]; then
    echo "no arguments"
    exit 1
fi

TARGET_FUNCTION="$1"

#rm -rf package
#mkdir package
#
#cp -r ${TARGET_FUNCTION}/* package/.
#pip3 install -r "${TARGET_FUNCTION}/requirements.txt" -t ./package

cd package
# zip -r ${TARGET_FUNCTION}.zip .

# aws s3 cp ${TARGET_FUNCTION}.zip s3://${AWS_LAMBDA_BUCKET}/${TARGET_FUNCTION}.zip

# Check if function exists.
aws lambda get-function --function-name first_lambda > /dev/null
if [ 0 -eq $? ]; then
    aws lambda update-function-code --function-name ${TARGET_FUNCTION} \
        --zip-file fileb://${TARGET_FUNCTION}.zip
else
    aws lambda create-function --function-name ${TARGET_FUNCTION} \
        --runtime python3.11 \
        --handler main.main \
        --role ${AWS_LAMBDA_ROLE} \
        --zip-file fileb://${TARGET_FUNCTION}.zip
fi

