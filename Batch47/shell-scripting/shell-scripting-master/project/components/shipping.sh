#!/usr/bin/env bash

## Load Common Script

export SERVICE=shipping
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Shipping MicroService"

info "START  :: Install Java"
yum install java -y &>${TMP_LOG_FILE}
STAT $? "FINISH :: Install Java"

info "START  :: Add Application User"
createAppUser ${APP_USER}
STAT $? "FINISH :: Create Application User"

info "START  :: Clone Shipping Service Repository"
CLONE_APP ${SERVICE} ${APP_USER} &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Clone Shipping Service Repository"

info "START  :: Fix Permissions to Cart Service directory"
chown ${APP_USER}:${APP_USER} ${APP_HOME} -R
STAT $? "FINISH :: Fix Permissions"

info "START  :: Setup Cart SystemD Service"
envsubst < /home/${APP_USER}/${SERVICE}/${SERVICE}-ss.service > /etc/systemd/system/${SERVICE}.service
STAT $? "FINISH :: Setup Cart Service"

info "START  :: Start Shipping Service"
systemctl daemon-reload &>>${TMP_LOG_FILE}
systemctl enable shipping &>>${TMP_LOG_FILE}
systemctl start shipping &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Shipping Service"

