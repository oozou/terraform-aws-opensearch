#!/bin/bash -e
# wget to update opensearch backend role

wget --http-user=${username} --http-password=${password} \
  --method PUT \
  --header 'Content-Type: application/json' \
  --body-data '{
    "users" : [ "${username}" ],
    "backend_roles": ${backend_roles}
  }' \
   'https://${opensearch_endpoint}/_plugins/_security/api/rolesmapping/all_access'
sudo shutdown -h now
