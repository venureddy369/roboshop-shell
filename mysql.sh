##if [ -z "$1" ]
##  then
##    echo Input argument Password is needed
##     exit
##fi
#
##ROBOSHOP_MYSQL_PASSWORD=$1
#
#echo -e "\e[31mDownloading mysql file\e[0m"
#curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
#if [ $? -eq 0 ]; then
#  echo SUCCESS
#else
#    echo Failure
#    exit
#fi
#
#echo -e "\e[31mdisable mysql7 repo\e[0m"
#dnf module disable mysql -y
#
#if [ $? -eq 0 ]; then
#  echo SUCCESS
#else
#    echo Failure
#    exit
#fi
#
#echo -e "\e[31minstall mysql\e[0m"
#yum install mysql-community-server -y
#
#if [ $? -eq 0 ]; then
#  echo SUCCESS
#else
#    echo Failure
#    exit
#fi
#
#echo -e "\e[31menable mysql service\e[0m"
#systemctl enable mysqld
#
#if [ $? -eq 0 ]; then
#  echo SUCCESS
#else
#    echo Failure
#    exit
#fi
#
#echo -e "\e[31mstart mysql service\e[0m"
#systemctl restart mysqld
#
#if [ $? -eq 0 ]; then
#  echo SUCCESS
#else
#    echo Failure
#    exit
#fi
#
#echo show databases | mysql -uroot -pRoboShop@1   #-->if  this command giving output that means password changed
#if [ $? -ne 0 ]
#  then
##resetting of password
#
#    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/root-pass-sql
#    ##(here above cmnd we have entered the password but that not ac ode standards always don't hard code the passwords)
#
#
#    DEFAULT_PASSWORD=$(grep 'A temporary password is generated' /var/log/mysqld.log | awk '{print $NF}')
#
#
#    cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
#fi




############################################
if [ -z "$1" ]; then
  echo  password argument needed please enter:
  exit
fi

COMPONENT=redis
source common.sh

ROBOSHOP_MYSQL_PASSWORD=$1

PRINT "Downloading mysql file"
 curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
STAT $?

PRINT "disable mysql8 app version"
 dnf module disable mysql -y &>>$LOG
STAT $?


PRINT "installing mysql"
 yum install mysql-community-server -y &>>$LOG
STAT $?


PRINT "enabling mysql"
   systemctl enable mysqld &>>$LOG
STAT $?

PRINT "start mysql"
systemctl restart mysqld &>>$LOG
STAT $?

    echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG
    if [ $? -ne 0 ]
      then

         echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
         DEFAULT_PASSWORD=$(grep ' A temporary password' /var/log/mysqld.log | awk '{print $NF}')
         cat /tmp/root-pass-sql  | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" &>>$LOG
    fi

PRINT "Uninstall Validate plugin password"
echo "show plugins" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} | grep validate_password &>>$LOG

if [ $? -eq 0 ]; then

  echo "uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG

fi
STAT $?

APP_LOC=/tmp
CONTENT=mysql-main
DOWNLOAD_APP_CODE


cd mysql-main &>>$LOG

PRINT "Load Shipping schema"
mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>$LOG
STAT $?

