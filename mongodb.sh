source common.sh

print_head "Setup MongoDB repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Installing MongoDB "
yum install mongodb-org -y &>>${log_file}

print_head "Update MongoDB listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}

print_head "Start MongoDB Service "
systemctl restart mongod &>>${log_file}

## Update of the configuration file /etc/mongod.conf from 127 .0.0.1 with 0.0.0.0
# Now we want to edit the mongod.conf after the service is setup , so for that reason we are using
# sed editor which can edit changes in command line. now we have updates the mongod.conf file