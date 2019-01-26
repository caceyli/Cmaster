#!/bin/sh

echo "Usage:"
echo "Stop bdna agent and remove install home:sh disscript.sh"
echo "Upload files to other servers: sh disscript.sh -f 'file_path'"

while getopts "f:" opt; do
  case $opt in
    f)
      echo "this is -a the arg is ! $OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
  echo "test:$OPTARG"
  FILE=$OPTARG
  echo "file:$FILE"
  BDNA_SERVER_OS_USERNAME="bdna"
  bdna_ips[1]="192.168.11.18"
  bdna_ips[2]="192.168.11.19"
  bdna_ips[3]="192.168.9.107"
  bdna_ips[4]="192.168.10.145"
  bdna_ips[5]="192.168.11.45"

  echo ${bdna_ips[3]}
  for (( i = 1 ; i < 6 ; i++ ))
    do
    if [ ! -n $FILE ];then
      target_host=${bdna_ips[$i]}
      echo "[`date`] Stopping BDNA Agent on $target_host." | tee -a ./cacey.log
      ssh -q -o BatchMode=yes -o StrictHostKeyChecking=no $BDNA_SERVER_OS_USERNAME@$target_host "killall -9 java perl sqlplus 2>&1 > /dev/null" 2>&1 >> ./cacey.log
      if [ $? -gt 1 ]; then
         echo "ERROR: Failed to stop BDNA Agent on $target_host." 15
      else
         echo "[`date`] Stop BDNA Agent on $target_host........................SUCCEEDED." | tee -a ./cacey.log
      fi
      echo "[`date`] Remove install home on $target_host." | tee -a ./cacey.log
      ssh -q -o BatchMode=yes -o StrictHostKeyChecking=no $BDNA_SERVER_OS_USERNAME@$target_host "sudo rm -rf install773* 2>&1 > /dev/null" 2>&1 >> ./cacey.log
      if [ $? -gt 1 ]; then
         echo "ERROR: Failed to remove BDNA install home on $target_host." 15
      else
         echo "[`date`] Remove BDNA install home on $target_host........................SUCCEEDED." | tee -a ./cacey.log
      fi
    else
      target_host=${bdna_ips[$i]}
      echo "[`date`] Upload file $FILE to $target_host." | tee -a ./cacey.log
      cmd="scp -r $FILE  $BDNA_SERVER_OS_USERNAME@$target_host:/home/bdna"
      echo "$cmd"
      `eval $cmd`
      if [ $? -gt 1 ]; then
         echo "ERROR:Failed to Upload file $FILE to $target_host." 15
      else
         echo "[`date`] Upload file $FILE to $target_host........................SUCCEEDED." | tee -a ./cacey.log
      fi
    fi
  done
done
