#!/bin/bash -e
# install dependencies packages
echo "starting cloud init script . . ."
sudo su
sudo apt-get update
yes | sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install awscli
yes | sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install jq

# wget to update opensearch backend role
echo "update opensearch backend role"
aws configure set region ${region}
credential=$(aws secretsmanager get-secret-value  --secret-id ${os_bootstrap_secret_arn} --query SecretString --output text)
username=$(echo $credential | jq '.username' | tr -d '"')
password=$(echo $credential | jq '.password' | tr -d '"')
echo "user="$username >> .wgetrc
echo "password="$password >> .wgetrc
wget --method PUT \
  --header 'Content-Type: application/json' \
  --body-data '{
    "users" : [ "${username}" ],
    "backend_roles": ${backend_roles}
  }' \
   'https://${opensearch_endpoint}/_plugins/_security/api/rolesmapping/all_access'
sudo shutdown -h now
