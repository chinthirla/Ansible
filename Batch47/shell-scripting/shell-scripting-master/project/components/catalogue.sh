#!/usr/bin/env bash

## Load Common Script

export SERVICE=catalogue
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Catalogue MicroService"

info "START  :: Install NodeJS"
installNodeJS
STAT $? "FINISH :: Install NodeJS"

info "START  :: Add Application User"
createAppUser ${APP_USER}
STAT $? "FINISH :: Create Application User"

info "START  :: Clone Catalogue Repository"
CLONE_APP ${SERVICE} ${APP_USER} &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Clone Catalogue Repository"

info "START  :: Install NodeJS dependencies"
cd ${APP_HOME}
npm install &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install NodeJS Dependencies"

info "START  :: Fix Permissions to Catalogue directory"
chown ${APP_USER}:${APP_USER} ${APP_HOME} -R
STAT $? "FINISH :: Fix Permissions"

info "START  :: Setup Catalogue SystemD Service"
envsubst < /home/${APP_USER}/${SERVICE}/${SERVICE}-ss.service > /etc/systemd/system/${SERVICE}.service
STAT $? "FINISH :: Setup Catalogue Service"

info "START  :: Start Catalogue Service"
systemctl daemon-reload &>>${TMP_LOG_FILE}
systemctl enable catalogue &>>${TMP_LOG_FILE}
systemctl start catalogue &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Catalogue Service"

