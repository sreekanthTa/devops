#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
FILENAME=$(echo $0 | cut -d '.' -f1)
LOGFILE=/tmp/$FILENAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "starting backend script"

VALIDATE(){
    if [ $? -ne 0 ]
      then
         echo "$1 ... $R Failure $N"
         exit 1
    else
        echo "$1 ... $Y Success $N"
    fi
}

echo "checking user"

if [ $USERID -ne 0 ]
  then 
    echo "Please provide Root access to run this file"
    exit 1
  else
     echo "You are root user"
fi

echo "disable nodejs"

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "NODEJS DISABLE"

echo "enable nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "NODEJS ENABLE"

echo "install nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "INSTALL NODEJS"

echo "Add User"

id expense &>>$LOGFILE

if [$? -ne 0]
then
  useradd expense &>>$LOGFILE
  VALIDATE $? "USERADD EXPENSE"
else
 echo "User Already created"
fi



echo "Make app direcotry"

mkdir -p /app &>>$LOGFILE
VALIDATE $? "GO TO DIRECTOR"

echo "Make curl"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "DOWNLOAD ZIP FILE"

echo "Make curl"

cd /app &>>$LOGFILE

rm -rf /app/*


unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "UNZIP"


npm install &>>$LOGFILE
VALIDATE $? "INSTALL NODE"


cp /home/ec2-user/expense-script/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "COPY BACKEND SERVICE"


systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "RELOAD"


systemctl start backend &>>$LOGFILE
VALIDATE $? "ENABLE"


systemctl enable backend &>>$LOGFILE
VALIDATE $? "BACKEND"


dnf install mysql -y &>>$LOGFILE
VALIDATE $? "INSTALL MYSQL"


mysql -h 172.31.83.67 -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "LOAD SCHEMA"


systemctl restart backend &>>$LOGFILE
VALIDATE $? "RESTART BACKEND"


