curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
dnf module disable mysql -y

yum install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld

#resetting of password

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" >/tmp/root-pass-sql
##(here above cmnd we have entered the password but that not ac ode standards always don't hard code the passwords)


DEFAULT_PASSWORD=$(grep 'A temporary password is generated' /var/log/mysqld.log | awk '{print $NF}')


cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"