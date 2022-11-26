curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ]; then
  echo SUCCESS
else
    echo Failure
fi

dnf module disable mysql -y

if [ $? -eq 0 ]; then
  echo SUCCESS
else
    echo Failure
fi

yum install mysql-community-server -y

if [ $? -eq 0 ]; then
  echo SUCCESS
else
    echo Failure
fi

systemctl enable mysqld

if [ $? -eq 0 ]; then
  echo SUCCESS
else
    echo Failure
fi
systemctl start mysqld

if [ $? -eq 0 ]; then
  echo SUCCESS
else
    echo Failure
fi

echo show databases | mysql -uroot -pRoboshop@1   #-->if  this command giving output that means password changed
if [ $? -ne 0 ]
  then
#resetting of password

    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" >/tmp/root-pass-sql
    ##(here above cmnd we have entered the password but that not ac ode standards always don't hard code the passwords)


    DEFAULT_PASSWORD=$(grep 'A temporary password is generated' /var/log/mysqld.log | awk '{print $NF}')


    cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi