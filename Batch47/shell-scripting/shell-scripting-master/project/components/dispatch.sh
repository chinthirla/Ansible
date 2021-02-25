#!/usr/bin/env bash

## Load Common Script

export SERVICE=dispatch
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Dispatch MicroService"

info "START  :: Add Application User"
createAppUser ${APP_USER}
STAT $? "FINISH :: Create Application User"

info "START  :: Clone Dispatch Repository"
CLONE_APP ${SERVICE} ${APP_USER} &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Clone Dispatch Repository"

info "START  :: Fix Permissions to Dispatch directory"
chmod ugo+x ${APP_HOME}/dispatch
chown ${APP_USER}:${APP_USER} ${APP_HOME} -R &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Fix Permissions"

info "START  :: Setup Dispatch SystemD Service"
envsubst < /home/${APP_USER}/${SERVICE}/${SERVICE}-ss.service > /etc/systemd/system/${SERVICE}.service
STAT $? "FINISH :: Setup Dispatch Service"

info "START  :: Start Dispatch Service"
systemctl daemon-reload &>>${TMP_LOG_FILE}
systemctl enable dispatch &>>${TMP_LOG_FILE}
systemctl start dispatch &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Dispatch Service"
