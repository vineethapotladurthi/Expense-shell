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

dnf module disable nodejs -y &>>LOG_FILE
validate $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>LOG_FILE
validate $? "enabling nodejs 20"

dnf install nodejs -y &>>LOG_FILE
validate $? "installing nodejs"

id Expense &>>LOG_FILE
if [ $? -ne 0 ]
then
    echo "expense user not exist"
    useradd expense
    validate $? "adding system user"
else
    echo "expense user already exists"
fi