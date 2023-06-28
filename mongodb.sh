source common.sh

print_head "Setup MongoDB repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Installing MongoDB "
yum install mongodb-org -y &>>${log_file}

print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}

print_head "Start MongoDB Service "
systemctl start mongod &>>${log_file}

## Update of the configuration file /etc/mongod.conf from 127 .0.0.1 with 0.0.0.0
#