#!/usr/bin/env bash

## Load Common Script

export SERVICE=user
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : User MicroService"

info "START  :: Install NodeJS"
installNodeJS
STAT $? "FINISH :: Install NodeJS"

info "START  :: Add Application User"
createAppUser ${APP_USER}
STAT $? "FINISH :: Create Application User"

info "START  :: Clone User Service Repository"
CLONE_APP ${SERVICE} ${APP_USER} &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Clone User Service Repository"

info "START  :: Install NodeJS dependencies"
cd ${APP_HOME}
npm install &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install NodeJS Dependencies"

info "START  :: Fix Permissions to User Service directory"
chown ${APP_USER}:${APP_USER} ${APP_HOME} -R
STAT $? "FINISH :: Fix Permissions"

info "START  :: Setup User SystemD Service"
envsubst < /home/${APP_USER}/${SERVICE}/${SERVICE}-ss.service > /etc/systemd/system/${SERVICE}.service
STAT $? "FINISH :: Setup User Service"

info "START  :: Start User Service"
systemctl daemon-reload &>>${TMP_LOG_FILE}
systemctl enable user &>>${TMP_LOG_FILE}
systemctl start user &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start User Service"

