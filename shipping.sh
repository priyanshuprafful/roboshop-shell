source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing MySql Root Password Argument\e[0m" # printing error in red color
  exit 1
fi

component=shipping
schema_type="mysql"
java