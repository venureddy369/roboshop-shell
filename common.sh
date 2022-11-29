STAT(){

  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
      echo -e "\e[33mFailure\e[0m"
      echo "check the error in $LOG file"
      exit
  fi
}

PRINT(){
  echo "---------$1--------" >>${LOG}
  echo -e "\e[31m$1\e[0m"
}

LOG=/tmp/$COMPONENT.log
rm -f $LOG

DOWNLOAD_APP_CODE(){
if [ ! -z "${APP_USER}" ]; then
   PRINT "Adding application user"
   id roboshop &>>$LOG
   if [ $? -ne 0 ]; then
     useradd roboshop &>>$LOG
   fi
   STAT $?
fi

  PRINT "Download App content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  STAT $?


  PRINT "Remove previous version of app"
  cd ${APP_LOC} &>>$LOG
  rm -rf ${CONTENT} &>>$LOG
  STAT $?

  PRINT "Extracting app content"
  unzip -o /tmp/${COMPONENT}.zip &>>$LOG
  STAT $?

}

SYSTEMD_SETUP(){

   PRINT "setup systemd service"

    sed -i -e 's/MONGO_DNSNAME/dev-mongodb.venudevops.online/' -e 's/REDIS_ENDPOINT/dev-redis.venudevops.online/' -e 's/CATALOGUE_ENDPOINT/dev-catalogue.venudevops.online/' -e 's/MONGO_ENDPOINT/dev-mongodb.venudevops.online/' -e 's/CARTENDPOINT/dev-cart.venudevops.online/' -e 's/DBHOST/dev-mysql.venudevops.online/' -e 's/AMQPHOST/dev-rabbitmq.venudevops.online/' -e 's/CARTHOST/dev-cart.venudevops.online/' -e 's/USERHOST/dev-user.venudevops.online/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG
    STAT $?

    PRINT "Reload systemd"
    systemctl daemon-reload &>>$LOG
    STAT $?

    PRINT "restart ${COMPONENT}"
    systemctl restart ${COMPONENT} &>>$LOG
    STAT $?

    PRINT "enable ${COMPONENT}"
    systemctl enable ${COMPONENT} &>>$LOG
    STAT $?
}

NODEJS(){
  APP_LOC=/home/roboshop
  CONTENT=${COMPONENT}
  APP_USER=roboshop
  PRINT "Download NodeJs repo file"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
  STAT $?

  PRINT "Install nodejs"
  yum install nodejs -y &>>$LOG
  STAT $?
  DOWNLOAD_APP_CODE
  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Install nodejs dependencies"
  npm install &>>$LOG
  STAT $?


  PRINT "Configure endpoints for Systemd Configuration"
  sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devops.online/' systemd.service &>>$LOG
  STAT $?

  SYSTEMD_SETUP

}


JAVA(){

 APP_LOC=/home/roboshop
 CONTENT=${COMPONENT}
 APP_USER=roboshop

  PRINT "Install Maven"
  yum install maven -y &>>$LOG
  STAT $?

  DOWNLOAD_APP_CODE

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT " Download Maven dependencies"
  mvn clean package&>>$LOG && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>$LOG
  STAT $?

  SYSTEMD_SETUP
}

PYTHON(){
  APP_LOC=/home/roboshop
   CONTENT=${COMPONENT}
   APP_USER=roboshop

   PRINT "Install Python3"
   yum install python36 gcc python3-devel -y &>>$LOG
   STAT $?


    DOWNLOAD_APP_CODE

     mv ${COMPONENT}-main ${COMPONENT}
     cd ${COMPONENT}

     PRINT "Install Dependencies"
     pip3 install -r requirements.txt &>>$LOG
     STAT $?

     USER_ID=$(id -u roboshop)
     GROUP_ID=$(id -g roboshop)
     sed -i -e "/uid/ c uid =${USER_ID}" -e "/uid/ c uid =${GROUP_ID}" ${COMPONENT}.ini

    SYSTEMD_SETUP

}