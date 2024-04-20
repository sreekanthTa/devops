#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d '.' -f)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

echo "SCRIPT STARTING, FILE NAME IS $LOGFILE"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    
    if [$1 -ne 0] 
    then
        echo -e "$2...$R Failure $N"
        exit 1
    else
       echo -e "$2...$G Sucess $N"
    fi
}

if [USERID -ne 0]
then
   echo "Please run this scritp as a root user"
   exit 1
else
  echo "You are super user"

fi

dnf install mysql-server -y
VALIDATE $? "MySql Server"

dnf enable mysqld
VALIDATE $? "Enable MySql Server"

dnf start mysqld
VALIDATE  $? "Start MySql Server"

mysql -h  -uroot -pExpenseApp@1 -e 'show databases;'

if [ $? -ne 0]
then
 echo "mysql_secure_installation --set-root-pass ExpenseApp@1"
 VALIDATE $? "MySql root password setup"
else
 echo "mysql password is already setup ... Skipping"
fi