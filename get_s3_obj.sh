#!/bin/bash

set -eux

# Path to your test file
bucket_name="$1"
req_path="$2"

# We need the current date to calculate the signature and also to pass to S3/GCS
curr_date=`date +'%a, %d %b %Y %H:%M:%S %z'`

# This is the name of your S3/GCS bucket
token="x-amz-security-token:${AWS_SESSION_TOKEN}"
content_type='application/x-compressed-tar'
string_to_sign="GET\n\n${content_type}\n${curr_date}\n$token\n/${bucket_name}${req_path}"

# Your secret
secret=$AWS_SECRET_ACCESS_KEY

# Your S3 key
s3_key=$AWS_ACCESS_KEY_ID

# We will now calculate the signature to be sent as a header.
signature=$(echo -en "${string_to_sign}" | openssl sha1 -hmac "${secret}" -binary | base64)

# That's all we need. Now we can make the request as follows.

# S3
curl -v -H "Host: ${bucket_name}.s3.amazonaws.com" \
        -H "Authorization: AWS ${s3_key}:${signature}" \
        -H "Content-Type: ${content_type}"  \
        -H "Date: $curr_date" \
        -H "${token}" \
        "https://${bucket_name}.s3.amazonaws.com${req_path}"
