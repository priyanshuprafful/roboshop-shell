code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[36m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo "Success"
  else
    echo "Failure"
    echo "Read the log file in  ${log_file} for more information about error"
    exit 1
  fi
}

systemd_setup() {
    print_head "Copy SystemD service File"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}

    print_head "Reload SystemD"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    print_head "Enable ${component} Service"
    systemctl enable ${component} &>>${log_file}
    status_check $?

    print_head "Starting ${component} service"
    systemctl restart ${component} &>>${log_file} ## better to give restart instead of start so that any changes occur it gets impacted
    status_check $?
}

schema_setup() {
  if [ "${schema_type}" == "mongo" ]; then
    print_head "Copy MongoDB repo file "
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status_check $?

    print_head "Installing Mongo Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema "
    mongo --host mongodb.saraldevops.online </app/schema/${component}.js &>>${log_file}
    status_check $?

  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install MySql Client"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql.saraldevops.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file # loading the schema and connecting to the server
    status_check $?
  fi



}
app_prereq_setup() {
  print_head "Create RoboShop User"
    id roboshop &>>${log_file}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${log_file}
    fi
    status_check $?


    print_head "Creating Application Directory"
    if [ ! -d /app ]; then
      mkdir /app &>>${log_file}
    fi
    status_check $?


    print_head "Deleting Old Content"
    rm -rf /app/* &>>${log_file}
    status_check $?


    print_head "Downloading App content"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    status_check $?

    cd /app

    print_head "Extracting App Content"
    unzip /tmp/${component}.zip &>>${log_file}
    status_check $?
}

nodejs() {


  print_head "Configure NodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?


  print_head "Installing NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?


  app_prereq_setup
  ## cd /app ## not needed as we are already in same directory

  print_head "Installing NodeJS Dependencies"
  npm install &>>${log_file}
  status_check $?


  schema_setup

  systemd_setup
}

java() {
  print_head "Install Maven"
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Downloading Dependencies & Package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status_check $?

  schema_setup # it is a function we have defined above

  systemd_setup # it is a function we have defined above

#  systemctl daemon-reload # after loading the schema then only we are starting these services it is also fine
 # systemctl enable shipping # after loading the schema then only we are starting these services it is also fine
 # systemctl start shipping # after loading the schema then only we are starting these services it is also fine
 # so here we are setting up the schema first and then only we are starting our service
 # all these are now the part of systemd_setup
}
python() {
  print_head "Installing Python"
  yum install python36 gcc python3-devel -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Downloading Dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  status_check $?

  systemd_setup
}