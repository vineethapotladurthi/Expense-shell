#!/bin/bash


SOURCE_DIR='/home/ec2-user/logs'
if [ -d $SOURCE_DIR ]
then
 echo " exists......"
 else
  echo "doesnot exist..."
  exit 1
fi
FILES=$(find  $(SOURCE_DIR) -name "*.log" -mtime +14)
echo "FILES:$FILES"
while IFS=read -r line #internal feild separator empty it ignore white space -r ignores special characters like /
do
 echo " deleting line:$lne"
 #rm -rf $line
done >>> $FILES
