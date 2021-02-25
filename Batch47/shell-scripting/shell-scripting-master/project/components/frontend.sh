#!/usr/bin/env bash

## Load Common Script

export SERVICE=frontend
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Frontend MicroService"

info "START  :: Install Nginx"
yum install nginx -y &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install Nginx"

info "START  :: Cloning Frontend Repository, Copying Nginx Files"
CLONE_TMP ${SERVICE} &>>${TMP_LOG_FILE}
cp /tmp/frontend/nginx-localhost.conf /etc/nginx/nginx.conf &>>${TMP_LOG_FILE}
rm -rf /usr/share/nginx/html
cp -r /tmp/frontend/static /usr/share/nginx/html &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Cloning Frontend Repository, Copying Nginx Files"

info "START  :: Start Nginx Service"
systemctl enable nginx  &>>${TMP_LOG_FILE}
systemctl start nginx &>>${TMP_LOG_FILE}
STAT $?  "FINISH :: Start Nginx Service"
