yum install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl enable nginx
systemctl start nginx
 ##Roboshop not configured or roboshop configuration is not copied as all the servers are not ready
 ## If any command is a failure or errored , we need to stop the script there itself , we will learn that later .
