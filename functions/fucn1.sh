#!/bin/bash

USERID=0
TIMESTAMP=$(date +%F-%H-%M-%s)
SCRIPTNAM=$(echo $0 | cut -d '.' -f1)
LOGFI=/tmp/$SCRIPTNAM-$TIMESTAMP

echo "starting script "

VALIDATE(){

   if [ $1 -ne 0 ] 
   then
	   echo "$2 ... Failure"
           exit 1
   else
	   echo "$2 ... Sucess"
   fi

}

if [ $USERID -ne 0 ]
then
	echo "Please run this script with root access"
else
	echo "You are super user here"
fi

dnf install mysql -y &>>$LOGFI
VALIDATE $? "Installing Mysql"

echo "completed"

