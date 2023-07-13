source common.sh


roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing Roboshop Password Argument\e[0m" # printing error in red color
  exit 1
fi

component=payment
python