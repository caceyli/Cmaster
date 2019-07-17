#!/bin/bash

bdnaHome=`echo $BDNA_HOME`
hostName=`hostname | sed "s/\..*//g"`
echo $bdnaHome
os=`cat /etc/redhat-release 2>/dev/null | egrep "Red Hat Enterprise [7].*|CentOS Linux.*release [7].*"`
if [ -n "$os" ]; then
  echo $os
  ethName=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g' |grep -v ^[lv]`
  dbHost="192.168.11.45"
  schemaName="$hostName"773
  sid="ora12c"
else 
  ethName="eth0"  
  dbHost=`/sbin/ifconfig $USER_SPECIFIED_INTERFACE 2>&1 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`
  schemaName="$hostName"772
  sid="ora11g"
fi
echo $schemaName
echo $ethName
echo $dbHost
echo "sh $bdnaHome/bin/configure.sh -e $ethName"
`expect loadseq.expect $ethName $bdnaHome $dbHost $sid$`
echo $? 
