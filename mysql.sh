source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing MySql Root Password Argument\e[0m" # printing error in red color
  exit 1
fi

print_head "Disabling MySql 8 version "
yum module disable mysql -y &>>${log_file}
status_check $?

print_head "Installing Mysql Server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable MySql Service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Starting mysql service"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set Password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?

## mysql -uroot -pRoboShop@1 , it is for checking whether the password change is working or not