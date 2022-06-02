#!/bin/bash
#
# script to create the Slack connector and the Security rules
#


curl -sS -u admin:changeme 'http://localhost:5601/api/actions/connector' \
  -H 'Content-Type: application/json' \
  -H 'kbn-version: 8.1.3' \
  --data-raw "$(vault read -field value secret/observability-team/ci/demo/slack-connector)"|jq .

CONNECTOR_ID=$(curl -sS -u admin:changeme 'http://localhost:5601/api/actions/connectors' \
  -H 'Content-Type: application/json' \
  -H 'kbn-version: 8.1.3' |jq '.[]|select(.name=="slack-cicd")'| jq -s -r '.|first|.id')

curl -sS -u admin:changeme 'http://localhost:5601/api/detection_engine/rules' \
  -H 'Content-Type: application/json' \
  -H 'kbn-version: 8.1.3' \
  --data-raw "$(cat demo-success-rule.json|sed s/CONNECTOR_ID/${CONNECTOR_ID}/)" |jq .

curl -sS -u admin:changeme 'http://localhost:5601/api/detection_engine/rules' \
  -H 'Content-Type: application/json' \
  -H 'kbn-version: 8.1.3' \
  --data-raw "$(cat demo-failure-rule.json|sed s/CONNECTOR_ID/${CONNECTOR_ID}/)"|jq .

curl -sS -u admin:changeme 'http://localhost:5601/api/detection_engine/rules' \
  -H 'Content-Type: application/json' \
  -H 'kbn-version: 8.1.3' \
  --data-raw "$(cat demo-snyk-error.json|sed s/CONNECTOR_ID/${CONNECTOR_ID}/)"|jq .

curl -sS -u admin:changeme 'http://localhost:5601/api/detection_engine/rules' \
  -H 'Content-Type: application/json' \
  -H 'kbn-version: 8.1.3' \
  --data-raw "$(cat demo-password-leak.json|sed s/CONNECTOR_ID/${CONNECTOR_ID}/)"|jq .
