#!/bin/bash

TIMESTAMP=$(date +%Y%m%d%H%M%S)
FILENAME=$( $0 |  cut -d '.' -f1)
LOGFILE=$TIMESTAMP-$FILENAME.log
echo "Starting $0 at $TIMESTAMP" >> $LOGFILE

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$? ..$R Failure $N" &>>$LOGFILE
        exit 1
    else
        echo "$? .. $R Success  $N"

    fi
}

if[ $USERID -ne 0]
then
    echo "$R You must be root to run this script $N"
    exit 1
else
   echo "$G You are root user $N"
fi

dnf install nginx -y
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting Nginx"


curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downalod file"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

cd /usr/share/nginx/html/ &>>$LOGFILE

unzip /tmp/frontend.zip &>>$LOGFILE

cp "/home/ec2-user/devops/expense-script/frontend.service /etc/nginx/default.d/expense.conf" &>>$LOGFILE
VALIDATE $? "COPY FILE" &>>$LOGFILE

systemctl restart  nginx &>>$LOGFILE
VALIDATE $? "RESTARTING NGI"
