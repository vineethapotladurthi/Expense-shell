#!/bin/bash


LOGS_FOLDER="/var/sys/log/Expense"
mkdir -p $LOGS_FOLDER
SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
touch "$LOG_FILE"

USERID=$(id -u)
Red='\033[0;31m'
Green='\033[0;32m'
Normal='\033[0m'

Check_Root(){
    if [ $USERID -ne 0 ]
    then
     echo -e " ${Red} you have to run the script under root previleges.." | tee -a $LOG_FILE
     exit 1
    fi
}
validate(){
    if [ $1 -ne 0 ]
    then
     echo -e "$2 ....${Red}failedd.......!" | tee -a $LOG_FILE
     exit 1
    else
        echo -e "$2...${Green}.. here you go successfully...." | tee -a $LOG_FILE
    fi
}
Check_Root
dnf install nginx -y 
validate $? "installing nginx"

systemctl enable nginx
validate $? "enabling nginx"

systemctl start nginx
validate $? "starting nginx..."

rm -rf /usr/share/nginx/html/*
validate $? "removing exited version"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate $? "accessing frontend application"

cd /usr/share/nginx/html
validate $? "changing directory"

unzip /tmp/frontend.zip
validate $? "unzip"

