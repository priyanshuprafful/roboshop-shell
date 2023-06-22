echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y
echo -e "\e[35mRemoving Old Content\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[35mDownloading Frontend Content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[35mExtracting Downloaded Frontend \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[35mCopying nginx configuration for roboshop \e[0m"
pwd
ls-l
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[35mEnabling nginx\e[0m"
systemctl enable nginx
echo -e "\e[35mStarting nginx\e[0m"
systemctl restart nginx
 ##Roboshop not configured or roboshop configuration is not copied as all the servers are not ready
 ## If any command is a failure or errored , we need to stop the script there itself , we will learn that later .
# Now the roboshop is configured
# we are getting this error that no such file found while running the scriptconfigs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf