#!/usr/bin/env bash

R="\e[1;31m"
G="\e[1;32m"
Y="\e[1;33m"
B="\e[1;34m"
N="\e[0m"

timeStamp() {
  date +%F-%T
}

export TMP_LOG_FILE=/tmp/tmp-roboshop.log

main() {

  echo -e "$(timeStamp) [${B}MAIN${N}] \t\e[1;35m$1${N}"
}

info() {

  echo -e "$(timeStamp) [${B}INFO${N}] \t$1"
}

STAT() {
  if [[ -f  ${TMP_LOG_FILE} ]]; then
    cat ${TMP_LOG_FILE} >>${LOG_FILE}
  fi
  case $1 in
    SKIP)
      echo -e "$(timeStamp) [${Y}SUCCESS${N}] \t$2"
      rm -f ${TMP_LOG_FILE}
      ;;
    0)
      echo -e "$(timeStamp) [${G}SUCCESS${N}] \t$2"
      rm -f ${TMP_LOG_FILE}
      ;;
    *)
      echo -e "$(timeStamp) [${R}ERROR${N}] \t$2"
      echo -e "${Y}"
      sed -e 's/^/ [ DEBUG ] /' ${TMP_LOG_FILE}
      rm -f ${TMP_LOG_FILE}
      echo -e "${N}"
      echo -e "\e Something went wrong, You can refer log file ${LOG_FILE} for more information"
      exit 2
      ;;
  esac
}

CLONE_TMP() {
  SERVICE=$1
  if [[ -d "/tmp/${SERVICE}" ]]; then
    rm -rf /tmp/${SERVICE}
  fi
  mkdir -p /tmp/${SERVICE}
  git clone https://${GIT_USER}:${GIT_PASS}@gitlab.com/batch47/robot-shop/${SERVICE}.git /tmp/${SERVICE}
}

CLONE_APP() {
  SERVICE=$1
  APP_USER=$2
  if [[ -d "/home/${APP_USER}/${SERVICE}" ]]; then
    cd /home/${APP_USER}/${SERVICE}
    git pull
    return $?
  fi
  mkdir -p /home/${APP_USER}/${SERVICE}
  git clone https://${GIT_USER}:${GIT_PASS}@gitlab.com/batch47/robot-shop/${SERVICE}.git /home/${APP_USER}/${SERVICE}
}

installNodeJS() {
  if [[ -e "/bin/node" ]]; then
    return 0
  fi
  URL=$(curl -s https://nodejs.org/en/download/ | xargs -n1 | grep linux-x64.tar | sed -e 's|=| |g' -e 's|>| |g'| xargs -n1 | grep ^http)
  FILENAME=$(echo $URL | awk -F / '{print $NF}')
  FOLDER_NAME=$(echo $FILENAME |sed -e 's/.tar.xz//')

  curl -s -o /tmp/$FILENAME $URL
  cd /opt
  tar -xf /tmp/$FILENAME
  mv $FOLDER_NAME nodejs
  ln -s /opt/nodejs/bin/node /bin/node
  ln -s /opt/nodejs/bin/npm /bin/npm
  ln -s /opt/nodejs/bin/npx /bin/npx
}

createAppUser() {
  id $1 &>/dev/null
  if [[ $? -eq 0 ]]; then
    return 0
  fi
  useradd $1
}