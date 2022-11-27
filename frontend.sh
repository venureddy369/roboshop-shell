COMPONENT=frontend
source common.sh
CONTENT="*"


PRINT "Installing NGINX"
yum install nginx -y &>>$LOG
STAT $?
APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE

mv frontend-main/static/* .

PRINT "Copy Roboshop Configuration File"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $?

PRINT "enable nginx"
systemctl enable nginx
STAT $?

PRINT "start nginx"
systemctl restart nginx
STAT $?

