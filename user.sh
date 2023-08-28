#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOGFILE

VALIDATE $? "Setting up NPM source"

yum install nodejs -y &>>LOGFILE

VALIDATE $? "Installing NPM"

useradd roboshop &>>LOGFILE

mkdir /app &>>LOGFILE

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>LOGFILE

VALIDATE $? "Downloading catalogue artifact"

cd /app &>>LOGFILE

VALIDATE $? "Moving in to app directory"

unzip /tmp/user.zip &>>LOGFILE

VALIDATE $? "Unzipping user"

npm install &>>LOGFILE

VALIDATE $? "Installing NPM"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>LOGFILE

VALIDATE $? "Copying user.service"

systemctl daemon-reload &>>LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable user &>>LOGFILE

VALIDATE $? "Enabling user"

systemctl start user &>>LOGFILE

VALIDATE $? "Starting user"