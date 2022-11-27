source common.sh

PRINT "Download NodeJs repo file"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

STAT $?

PRINT "Install nodejs"
yum install nodejs -y
STAT $?


PRINT "Adding application user"

useradd roboshop

STAT $?

PRINT "Download App content"


curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"

STAT $?

PRINT "Remove previous version of app"
cd /home/roboshop
rm -rf cart

STAT $?

PRINT "Extracting app content"
unzip -o /tmp/cart.zip

STAT $?


mv cart-main cart
cd cart

PRINT "Install nodejs dependencies"
npm install

STAT $?

PRINT "Configure endpoints for Systemd Configuration"

sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devops.online/' systemd.service

STAT $?


PRINT "setup systemd service"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
STAT $?

PRINT "Reload systemd"
systemctl daemon-reload
STAT $?

PRINT "restart cart"
systemctl restart cart
STAT $?
PRINT "enable cart"
systemctl enable cart
STAT $?