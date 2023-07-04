source common.sh

print_head "Configure NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?


print_head "Installing NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?


print_head "Create RoboShop User"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?


print_head "Creating Application Directory"
if [ ! -d/app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?


print_head "Deleting Old Content"
rm -rf /app/* &>>${log_file}
status_check $?


print_head "Downloading App content"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?

cd /app

print_head "Extracting App Content"
unzip /tmp/user.zip &>>${log_file}
status_check $?
## cd /app ## not needed as we are already in same directory

print_head "Installing NodeJS Dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD service File"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable User Service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Starting User service"
systemctl restart user &>>${log_file} ## better to give restart instead of start so that any changes occur it gets impacted
status_check $?

print_head "Copy MongoDB repo file "
cp ${code_dir}/user/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "Installing Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema "
mongo --host mongodb.saraldevops.online </app/schema/user.js &>>${log_file}
status_check $?