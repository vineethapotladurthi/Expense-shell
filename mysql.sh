#!/bin/bash


LOGS_FOLDER="/var/log/Expense"
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

dnf install mysql-server -y &>>$LOG_FILE
validate $? "mysql server.....! installation"

systemctl enable mysqld 2>&1 | tee -a $LOG_FILE
validate $? "enblaing mysqlserver"

systemctl start mysqld  &>>$LOG_FILE
validate $? "started mysqlserverere..!"

mysql -h mysql.vinusproject.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "root ${Red} pswd is not setup" &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    validate $? "seting up root password"
else
    echo -e "${Green}...already settuped.."
fi