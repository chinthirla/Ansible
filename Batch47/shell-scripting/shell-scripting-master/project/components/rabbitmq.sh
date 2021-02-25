#!/usr/bin/env bash

## Load Common Script

source components/common.sh

main "Start Setup : RabbitMQ"

info "START  :: Install Erlang"
yum list installed | grep esl-erlang &>/dev/null
if [[ $? -eq 0 ]]; then
  STAT SKIP "FINISH :: Install Erlang"
else
  yum install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.2.1-1~centos~7_amd64.rpm -y  &>>${TMP_LOG_FILE}
  STAT $? "FINISH :: Install Erlang"
fi

info "START  :: Setup YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Setup YUM Repos"

info "START  :: Install RabbitMQ"
yum install rabbitmq-server -y &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Install RabbitMQ"

info "START  :: Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>${TMP_LOG_FILE}
systemctl start rabbitmq-server &>>${TMP_LOG_FILE}
STAT $? "FINISH :: Start RabbitMQ Service"
