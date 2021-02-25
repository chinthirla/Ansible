#!/usr/bin/env bash

## Load Common Script

export SERVICE=ratings
export APP_USER=roboshop
export APP_HOME=/home/${APP_USER}/${SERVICE}


source components/common.sh

main "Start Setup : Ratings MicroService"
info "START  :: Setup PHP YUM Repos"
yum list installed | grep remi-release-7 &>/dev/null
if [[ $? -eq 0 ]]; then
  STAT SKIP "FINISH :: Setup PHP YUM Repos"
else
  yum install  http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>${TMP_LOG_FILE}
  STAT $? "FINISH :: Setup PHP YUM Repos"
fi

info "START  :: Install Apache Web Server"
yum install httpd yum-utils -y &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install Apache Web Server"

info "START  :: Install PHP"
yum-config-manager --enable remi-php73 &>/dev/null
yum -y install php php-opcache php73-php-pdo composer &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install PHP"

info "START  :: Update HTTPD Configuration"
sed -i '/^Listen/ c Listen 7004' /etc/httpd/conf/httpd.conf &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Update HTTPD Configuration"

info "START  :: Update HTDOCS from Cloned Repository"
CLONE_TMP ratings &>>${TMP_LOG_FILE}
cp /tmp/ratings/status.conf /etc/httpd/conf.d/ &>>${TMP_LOG_FILE}
rm -rf /var/www/html &>>${TMP_LOG_FILE}
cp -r /tmp/ratings/html /var/www/html &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Update HTDOCS from Cloned Repository"


info "START  :: Install PHP dependencies"
cd /var/www/html
composer install &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install PHP dependencies"

info "START  :: Start Apache Web Server"
systemctl enable httpd  &>>${TMP_LOG_FILE}
systemctl start httpd &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start Apache Web Server"




