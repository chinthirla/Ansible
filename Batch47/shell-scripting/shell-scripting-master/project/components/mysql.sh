#!/usr/bin/env bash

## Load Common Script

source components/common.sh

main "Start Setup : MySQL"

info "START  :: Downloading MySQL"
cd /tmp
yum list installed | grep mysql-community-server &>/dev/null
if [[ $? -eq 0 ]]; then
  STAT SKIP "FINISH :: Skip Download due to package already installed"
else
  if [[ ! -f /tmp/mysql-community-server-5.7.28-1.el7.x86_64.rpm ]]; then
    wget -O- https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar 2>${TMP_LOG_FILE} | tar -x
  fi
  STAT $? "FINISH :: Downloaded MySQL"
  info "START  :: Installing MySQL"
  yum remove mariadb-libs -y &>>${TMP_LOG_FILE}
  yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm \
              mysql-community-common-5.7.28-1.el7.x86_64.rpm \
              mysql-community-libs-5.7.28-1.el7.x86_64.rpm \
              mysql-community-server-5.7.28-1.el7.x86_64.rpm -y &>>${TMP_LOG_FILE}
  STAT $? "FINISH :: Install MySQL"
fi

info "START  :: Start Service MySQL"
systemctl enable mysqld &>>${TMP_LOG_FILE}
systemctl start mysqld &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Started MySQL"

sleep 10

echo 'show databases' | mysql -uroot -ppassword &>/dev/null
if [[ $? -ne 0 ]]; then
  info "START  :: Reset root user Password"
  MYSQL_TEMP_PASSWORD=$(cat /var/log/mysqld.log | grep 'temporary password' | tail -1 | awk '{print $NF}')
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/remove-plugin.sql
  mysql --connect-expired-password -uroot -p${MYSQL_TEMP_PASSWORD} </tmp/remove-plugin.sql  &>>${TMP_LOG_FILE}
  STAT $? "FINISH :: Reset root password"
fi

info "START :: Cloning MySQL for Schema Loading"
CLONE_TMP mysql &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Cloned MySQL Repository"

info "START :: Loading Schema"
mysql -uroot -ppassword </tmp/mysql/ratings.sql &>>${TMP_LOG_FILE}
mysql -uroot -ppassword </tmp/mysql/shipping.sql &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Loaded Schema"