#!/usr/bin/env bash

alias AWX="awx --conf.host http://172.31.63.158 --conf.username ${AWX_USR} --conf.password ${AWX_PSW} -k"
ORG_ID=2

if [[ -z "${AWX_USR}" || -z "${AWX_PSW}" ]]; then
  echo "AWX Credentials are Missing"
  exit 1
fi

ENV=$2

TRIGGER_JOB() {
  JOB_TEMPLATE_ID=$(AWX job_templates list -f human | grep -i ${SERVICE_NAME} | awk '{print $1}')
  if [[ ! -z "${TAGS}" ]]; then
    TAG="--job_tags ${TAGS}"
  fi
  if [[ -z "$1" ]]; then
    AWX job_templates modify --id ${JOB_TEMPLATE_ID} --inventory ${SERVICE_NAME} ${TAG}
  else
    echo -e "APP_VERSION : $1\nARTIFACTS: NEXUS\nENVIRONMENT: ${ENVIRONMENT}\nENV: ${ENV}" >/tmp/vars.yml
    AWX job_templates modify --id ${JOB_TEMPLATE_ID} --inventory ${SERVICE_NAME} --extra_vars @/tmp/vars.yml ${TAG}
  fi
  AWX job_templates launch --id ${JOB_TEMPLATE_ID} --wait
  exit $?
}
# Check Connection
AWX me -f human | grep admin &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "AWX Connection - Successful"
else
  echo "AWX Connection - Failure"
  exit 1
fi

## Check Inventory
if [[ -z "$1" ]]; then
  echo "Inventory Input is missing"
  exit 1
fi

SERVICE_NAME=$(echo $1 | tr [a-z] [A-Z])


## Check host input is available or not
if [[ -z  "${PRIVATE_IP}" ]]; then
  echo "Server IP is empty"
  exit 1
fi

if [[ "$PRIVATE_IP" == "NONE" ]]; then
  TRIGGER_JOB ${VERSION}
elif [[ ! -z "${APP_VERSION}" && ! -z "${IS_TEST}" ]]; then
  ENV=test
  ENVIRONMENT=dev
  TRIGGER_JOB ${APP_VERSION}
fi

## ADD Inventory
AWX inventory delete ${SERVICE_NAME}
  AWX inventory create --name ${SERVICE_NAME} --organization ${ORG_ID} &>/tmp/awx
  if [[ $? -eq 0 ]]; then
    echo "Inventory ${SERVICE_NAME} Creation Successful"
  else
    echo "Inventory ${SERVICE_NAME} Creation Failure"
    cat /tmp/awx
    exit 1
  fi

# Check Host already exists
AWX hosts list -f human | grep -w ${PRIVATE_IP} &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "Host ${PRIVATE_IP} already exists in inventory"
else
# ADD Host
  AWX hosts create --inventory ${SERVICE_NAME} --name ${PRIVATE_IP} --variables "{\"ENV\": \"${ENV}\"}" &>/tmp/awx
  if [[ $? -eq 0 ]]; then
    echo "Host Add to  ${SERVICE_NAME} Inventory - Successful"
  else
    echo "Host Add to  ${SERVICE_NAME} Inventory - Failure"
    cat /tmp/awx
    exit 1
  fi
fi

# Check Template
AWX job_templates list -f human | grep ${SERVICE_NAME} &>/dev/null
if [[ $? -eq 0 ]]; then
  echo "Job Template - ${SERVICE_NAME} - exists"
else
  echo "Job Template - ${SERVICE_NAME} - not exists"
  exit 1
fi

TRIGGER_JOB