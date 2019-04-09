#!/bin/bash

mkdir -p ~/.aws/
touch ~/.aws/credentials
printf "[eb-cli]\naws_access_key_id = %s\naws_secret_access_key = %s\n" "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" > ~/.aws/credentials
touch ~/.aws/config
printf "[profile eb-cli]\nregion=$AWS_REGION\noutput=json" > ~/.aws/config