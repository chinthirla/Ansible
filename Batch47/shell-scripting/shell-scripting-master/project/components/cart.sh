#!/usr/bin/env bash

## Load Common Script

export SERVICE=cart
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Cart MicroService"

info "START  :: Install NodeJS"
installNodeJS
STAT $? "FINISH :: Install NodeJS"

info "START  :: Add Application User"
createAppUser ${APP_USER}
STAT $? "FINISH :: Create Application User"

info "START  :: Clone Cart Service Repository"
CLONE_APP ${SERVICE} ${APP_USER} &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Clone Cart Service Repository"

info "START  :: Install NodeJS dependencies"
cd ${APP_HOME}
npm install &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install NodeJS Dependencies"

info "START  :: Fix Permissions to Cart Service directory"
chown ${APP_USER}:${APP_USER} ${APP_HOME} -R
STAT $? "FINISH :: Fix Permissions"

info "START  :: Setup Cart SystemD Service"
envsubst < /home/${APP_USER}/${SERVICE}/${SERVICE}-ss.service > /etc/systemd/system/${SERVICE}.service
STAT $? "FINISH :: Setup Cart Service"

info "START  :: Start Cart Service"
systemctl daemon-reload &>>${TMP_LOG_FILE}
systemctl enable cart &>>${TMP_LOG_FILE}
systemctl start cart &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Cart Service"

