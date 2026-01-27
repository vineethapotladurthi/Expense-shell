#!/bin/bash

USERID=$(id -u)
R='\033[0;31m'
G='\e[32m'
N='\033[0m'

LOGS_FOLDER="/var/log/Expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGFILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER

# if [ $USERID -ne 0 ]; then
#     echo "you have to run the script under root previleges.."
#     exit 1
# fi
Check_Root(){
    if [ $USERID -ne 0 ]; then
     echo -e " $R you have to run the script under root previleges.." &>>$LOGFILE
     exit 1
    fi
}
validate(){
    if [ $1 -ne 0 ]; then
     echo -e "$R $2 failedd.......!" | tee -a $LOGFILE
     exit 1
    else
        echo -e "$G $2 here you go successfully...." | tee -a &>>$LOGFILE
    fi
}
Check_Root

dnf install mysql-server -y &>>$LOGFILE
validate $? "mysql server.....! installation"

systemctl enable mysqld  | tee -a &>>$LOGFILE
validate $? "enblaing mysqlserver"

systemctl start mysqld  &>>$LOGFILE
validate $? "started mysqlserverere..!"

mysql -h mysql.vinusproject.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]; then
    echo "root pswd is not setup"
    mysql_secure_installation --set-root-pass ExpenseApp@1
    validate $? "seting up root password"
    else
    echo " already settuped.."
fi

# for package in $@
# do 
#         echo "the  pakacge are $package" &>>LOGFILE
#         dnf list installed $package
#     if [ $? -ne 0 ]; then
#         echo -e " $R $package was not installed on your device let us install $package"&>>LOGFILE
#         dnf install $package -y
#     # if [ $? -ne 0 ]; then
#     #     echo "git installation was not success"
#     #     exit 1
#     # else
#     #     echo " git installed succcessfully"
#     # fi
#         validate $? "$package installation"
#     else
#         echo  -e "$N $package was already iinstalled" | tee -a &LOGFILE
#     fi
# done

# dnf list installed mysql

#  if [ $? -ne 0 ]
#   then
#     echo -e "$R $package was not installed on your device let us install $package"&>>LOGFILE
#     dnf install $package -y
#     if [ $? -ne 0 ]
#      then
#         echo -e "$R $package installation was not success"&>>LOGFILE
#         exit 1
#     else
#         echo -e "$G $package installed succcessfully"&>>LOGFILE
#     fi
# else
#     echo -e "$N $package was already iinstalled"&>>LOGFILE
# fi
