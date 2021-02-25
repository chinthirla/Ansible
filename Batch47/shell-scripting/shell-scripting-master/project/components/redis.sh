#!/usr/bin/env bash

## Load Common Script

source components/common.sh

main "Start Setup : Redis"
info "START  :: Setting Up YUM repository"
yum install epel-release yum-utils -y &>>${TMP_LOG_FILE}
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>${TMP_LOG_FILE}
yum-config-manager --enable remi &>>${TMP_LOG_FILE}
STAT $? "FINISH :: YUM Repository Setup"

info "START  :: Installing Redis"
yum install redis -y &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install Redis"

info "START  :: Start Service Redis"
systemctl enable redis &>>${TMP_LOG_FILE}
systemctl start redis &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Service Redis"

