#!/bin/bash

num=1

if [ $num -gt 0 ]
then
   echo "first check"
else
   echo "lasasda "
fi

if [ $? -ne 0 ]
then
   echo "working"
else
   echo "adsfasd"
fi