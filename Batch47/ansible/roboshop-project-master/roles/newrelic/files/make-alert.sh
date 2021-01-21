#!/bin/bash 

API_KEY=$1
FILENAME=/tmp/$2

curl -s -X POST "https://infra-api.newrelic.com/v2/alerts/conditions" -H "X-Api-Key:$API_KEY" -H 'Content-Type: application/json' -d @$FILENAME | jq '.data' | jq '.id' >>/etc/newrelic-infra/alert-ids 
