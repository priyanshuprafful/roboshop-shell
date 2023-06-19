cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

## Update of the configuration file /etc/mongod.conf from 127 .0.0.1 with 0.0.0.0