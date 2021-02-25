#!/usr/bin/env bash

## Load Common Script

export SERVICE=payment
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Payment MicroService"

info "START  :: Install Python3"
yum install python36 gcc python3-devel -y &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install Python3"

info "START  :: Add Application User"
createAppUser ${APP_USER}
STAT $? "FINISH :: Create Application User"

info "START  :: Clone Payment Repository"
CLONE_APP ${SERVICE} ${APP_USER} &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Clone Payment Repository"

info "START  :: Install Python Dependencies"
cd ${APP_HOME}
pip3 install -r requirements.txt &>>${TMP_LOG_FILE}
STAT $?  "FINISH :: Install Python Dependencies"

info "START  :: Setup Payment SystemD Service"
envsubst < /home/${APP_USER}/${SERVICE}/${SERVICE}-ss.service > /etc/systemd/system/${SERVICE}.service
STAT $? "FINISH :: Setup Payment Service"

info "START  :: Start Payment Service"
systemctl daemon-reload &>>${TMP_LOG_FILE}
systemctl enable payment &>>${TMP_LOG_FILE}
systemctl start payment &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Payment Service"
