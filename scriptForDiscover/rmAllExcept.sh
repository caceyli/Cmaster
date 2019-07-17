#script Name: rmAllExcept #
#Note: This script is used to remove all files except the the ones specified following in parameters. #
#Point1: $# $@ #
#Point2: for if #
#Point2: grep -v, grep -v XX|grep -v XX #
#Point4: eval $cmd #

#!/bin/bash

if [ $# -lt 1 ];
then
  echo "please input the file name of files you want to remove"
  echo "Usage: ./rmAllExcept aa bb" (remove all files except the files aa bb)
  exit 0
else
  cmd="ls|grep -v rmAllExcept"

  for i in $@
  do
    cmd="$cmd |grep -v $i"
  done
  echo "$cmd"

  for filename in `eval $cmd`
  do
      rm -rf $filename
  done
fi