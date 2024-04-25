#!/bin/bash

SOURCE_DIRECTORY="../app"

if [ -d $SOURCE_DIRECTORY ]
then
  echo "Source directory exists"
else
  echo "Inv source directory $SOURCE_DIRECTORY"
  exit 1
fi

FILES=$(find $SOURCE_DIRECTORY -name "*.log" -mtime +14)

while IFS= read -r line
do
  echo "Deleting file"
  rm -f $line

  echo "File deleted"


done <<< $FILES