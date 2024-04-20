#!/bin/bash



echo "all variables $@"

echo "no of variables $#"

echo "Script name $0"

echo "HOME directory is  $HOME"

echo "USER directory is $USER"

echo "PRESENT working directory is $PWD"

echo "current pid is $$"

sleep 30 &

echo "last command pid is $!"

