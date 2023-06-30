source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
echo $?

print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/*
echo $?

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo $?

print_head "Extracting Downloaded Frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
echo $?

print_head "Copying nginx configuration for roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
echo $?

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
echo $?

print_head "Starting nginx"
systemctl restart nginx &>>${log_file}
echo $?
 ##Roboshop not configured or roboshop configuration is not copied as all the servers are not ready
 ## If any command is a failure or errored , we need to stop the script there itself , we will learn that later .
# Now the roboshop is configured
# we are getting this error that no such file found while running the scriptconfigs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
#We have solved this problem of directory not found as well .

## we want the status of a command to be printed