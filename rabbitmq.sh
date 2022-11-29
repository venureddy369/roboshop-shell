COMPONENT=rabbitmq
source common.sh

ROBOSHOP_APP_USER_PASS=$1
if [ -z "$1" ]
  then
    echo "Please enter password"
    exit
fi


PRINT "Install Erlang dependencies"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install Erlang"
yum install erlang -y &>>$LOG
STAT $?

PRINT "Setuo YUM Repos for Rabbit MQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install RabbitMQ"
yum install rabbitmq-server -y &>>$LOG
STAT $?

PRINT "enable rabbitmq service"
systemctl enable rabbitmq-server &>>$LOG
STAT $?

PRINT "Start RabbitMQ Service"
systemctl start rabbitmq-server &>>$LOG
STAT $?

PRINT "Create application user"
rabbitmqctl add_user roboshop ${ROBOSHOP_APP_USER_PASS} &>>$LOG
STAT $?

PRINT "setup application user tags"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG
STAT $?

PRINT "setup application user permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
STAT $?