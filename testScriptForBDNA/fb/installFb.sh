#!/bin/bash
kkill
sudo rm -rf install772 install772_4092/
sh /home/bdna/automation/installer/bdna_7.7.2_4092_20161117.installer -i
sh /home/bdna/install772/bin/configure.sh <fbcmds
if [ $? -e 0 ]; then 
  ./testfb  2>&1
fi
