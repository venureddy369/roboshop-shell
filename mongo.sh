COMPONENT=mongodb
source common.sh

PRINT "Download mangod repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?

PRINT "Install mangodb"
yum install -y mongodb-org &>>$LOG
STAT $?

PRINT "Configure mangod listen address "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
STAT $?

PRINT "Enable mangod service"
systemctl enable mongod &>>$LOG
STAT $?

PRINT "Start mangod service"
systemctl restart mongod &>>$LOG
STAT $?



APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE


cd mongodb-main &>>$LOG

PRINT "Load catalogue schema"
mongo < catalogue.js
STAT $?

PRINT "Load users schema"
mongo < users.js
STAT $?




