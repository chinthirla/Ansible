#!/bin/bash 

API_KEY=$1

for alert in `cat /etc/newrelic-infra/alert-ids`; do 

  curl -X DELETE "https://api.newrelic.com/v2/alerts_conditions/${alert}.json"  -H "X-Api-Key:${API_KEY}" -i
done

> /etc/newrelic-infra/alert-ids