source common.sh

print_head "Configure NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}

print_head "Installing NodeJS"
yum install nodejs -y &>>{log_file}

print_head "Create RoboShop User"
useradd roboshop &>>{log_file}

print_head "Creating Application Directory"
mkdir /app &>>{log_file}

print_head "Deleting Old Content"
rm -rf /app/* &>>{log_file}

print_head "Downloading App content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{log_file}
cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>{log_file}
## cd /app ## not needed as we are already in same directory

print_head "Installing NodeJS Dependencies"
npm install &>>{log_file}

print_head "Copy SystemD service File"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>{log_file}

print_head "Reload SystemD"
systemctl daemon-reload &>>{log_file}

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>{log_file}

print_head "Starting Catalogue service"
systemctl restart catalogue &>>{log_file} ## better to give restart instead of start so that any changes occur it gets impacted

print_head "Copy MongoDB repo file "
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}

print_head "Installing Mongo Client"
yum install mongodb-org-shell -y

print_head "Load Schema "
mongo --host mongodb.saraldevops.online </app/schema/catalogue.js

