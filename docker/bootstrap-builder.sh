#!/bin/bash

yum -y install git jq unzip tar

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# AWS Secrets to retreive
declare -a secrets=("BLDR_RDS_USER"
                    "BLDR_RDS_PASSWORD"
                    "BLDR_S3_ACCESS_KEY"
                    "BLDR_S3_SECRET_KEY"
                    "BLDR_OAUTH_CLIENT_ID"
                    "BLDR_OAUTH_CLIENT_SECRET"
                   )

# Retrive AWS Sectets
for secret in "${secrets[@]}"
do
  $(aws secretsmanager get-secret-value --secret-id $secret --query SecretString --output text --region us-east-1 | \
    jq -r 'to_entries[] | "export \(.key)=\(.value)"')
done

# Other Env Vars
export HAB_LICENSE=accept
export BLDR_POSTGRES_HOST=hab-database.c7bu6q2aenah.us-east-1.rds.amazonaws.com

git clone https://github.com/MikeLingenfelter/hab-bldr.git

cd hab-bldr
./install.sh

