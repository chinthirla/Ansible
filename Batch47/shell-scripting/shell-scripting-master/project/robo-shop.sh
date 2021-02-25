#!/usr/bin/env bash

# Variables
ACTION=$1
COMPONENT=$2

export LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

## Functions
USAGE() {
  case $1 in
    missing-arguments)
      echo "Missing Arguments!!"
      USAGE
      ;;
    invalid-arguments)
      echo "Invalid Arguments!!"
      USAGE
      ;;
    invalid-component)
      echo "Invalid Component Given, Must be one of the following !!"
      USAGE
      ;;
    nonroot-user)
      echo "You should run this script as a root user!!"
      echo
      USAGE
      ;;
    git-credentials)
      echo "Git Credentials are missing, export GIT_USER and GIT_PASS to the script"
      USAGE
      ;;
    *)
      echo -e "\e[33mUsage: \e[31m$0 \e[35minstall|reinstall|uninstall \e[36mcart|catalogue|frontend|dispatch|payment|ratings|shipping|user|rabbitmq|mysql|redis|mongodb|\e[4mall(default)\e[0m"
      exit 1
  esac
}

## Main Program
if [[ $# -lt 1 || $# -gt 2 ]]; then
  USAGE missing-arguments
fi

case $ACTION in
  install|uninstall|reinstall)
    :
   ;;
  *)
    echo debug invalid-arguments
    USAGE invalid-arguments
esac


if [[ -z "$COMPONENT" ]]; then
  WHICH_COMPONENT=all
else
  case $COMPONENT in
    cart|catalogue|frontend|dispatch|payment|ratings|shipping|user|rabbitmq|mysql|redis|mongodb)
      WHICH_COMPONENT=$COMPONENT
    ;;
    *)
      USAGE invalid-component
    ;;
  esac
fi

## Validate whether a root user or not
ID_USER=$(id -u)
if [[ ${ID_USER} -ne 0 ]]; then
  USAGE nonroot-user
fi

## Validate GIT Username and GIT Password is exported.
if [[ -z "${GIT_USER}" || -z "${GIT_PASS}" ]]; then
  USAGE git-credentials
fi

case $ACTION in
  install)
    if [[ "${WHICH_COMPONENT}" == "all" ]]; then
      for component in rabbitmq mysql redis mongodb cart catalogue frontend dispatch payment ratings shipping user; do
        sh components/${component}.sh
        STAT=$?
        if [[ $STAT -ne 0 ]]; then
          exit $STAT
        fi
      done
    else
      sh components/${COMPONENT}.sh
    fi
    ;;
  uninstall|reinstall)
    echo "Under Development"
    ;;
esac