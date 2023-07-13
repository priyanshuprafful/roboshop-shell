source common.sh

user_name=$1
roboshop_app_password=$2

if [-z "${user_name}" ]; then
  echo -e "\e[31mMissing RoboShop App UserName \e[0m"
  exit 1
fi

if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing RoboShop App Password \e[0m"
  exit 1
fi



print_head "Setup Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "Setup RabbitMQ Server"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "Installing RabbitMQ server and erlang  "
yum install rabbitmq-server erlang -y &>>${log_file} # installing both with single yum command
status_check $?

print_head "Enable RabbitMQ service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Start RabbitMQ service"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "Add Application User"
rabbitmqctl list_users | grep ${user_name} &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user ${user_name} ${roboshop_app_password} &>>${log_file}
fi
status_check $?

# rabbitmqctl set_user_tags roboshop adminstrator # setting tags can be ignored as well

print_head "Configure Permissions for App User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?