#!/usr/bin/env bash

## Load Common Script

source components/common.sh

main "Start Setup : MongoDB"

info "START :: Setting Up YUM repository"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb-org-4.2.repo
STAT $? "FINISH :: Setting Up YUM repository"

info "START :: Installing MongoDB"
yum install -y mongodb-org -y &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Installing MongoDB"

info "START :: Starting MongoDB Service"
systemctl enable mongod &>/dev/null
systemctl start mongod &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Starting MongoDB Service"

info "START :: Cloning MongoDB for Schema Loading"
CLONE_TMP mongodb &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Cloned MongoDB Repository"

info "START :: Loading Schema"
echo 'show dbs' | mongo  | grep catalogue &>/dev/null
if [[ $? -ne 0 ]]; then
  mongo /tmp/mongodb/catalogue.js &>>${TMP_LOG_FILE}
fi
echo 'show dbs' | mongo  | grep users &>/dev/null
if [[ $? -ne 0 ]]; then
  mongo /tmp/mongodb/users.js &>>${TMP_LOG_FILE}
fi
STAT $? "FINISH :: Loaded Schema"

