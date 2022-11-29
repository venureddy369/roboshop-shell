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

PRINT "Update Roboshop Configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.venudevops.online/' -e '/user/ s/localhost/dev-user.venudevops.online/' -e '/cart/ s/localhost/dev-cart.venudevops.online/' -e '/shipping/ s/localhost/dev-shipping.venudevops.online/' -e '/payment/ s/localhost/dev-payment.venudevops.online/' /etc/nginx/default.d/roboshop.conf

STAT $?

PRINT "enable nginx"
systemctl enable nginx
STAT $?

PRINT "start nginx"
systemctl restart nginx
STAT $?

