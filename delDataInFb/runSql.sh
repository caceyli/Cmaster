#!/bin/sh
print_usage()
{
    echo ""
    echo "delIncorrectDbs_Fb.sh -  Shell script to delete all wrong DB Names."
    echo ""
    echo "Usage: sh delIncorrectDbs_Fb.sh"
    echo ""
    exit 1
}

while getopts "h" opt
do
    case $opt in
    h) print_usage ; exit 0;;
    esac
done

if [ ! -f "./scripts.log" ];then
  rm -rf ./scripts.log
fi

LOG_FILE="./scripts.log"
CURRENT_DIR=`pwd`

# check whether it is a FactBase schema
echo "[`date`] Checking if the schema is a FactBase schema." | tee -a $LOG_FILE
IS_FACTBASE=`sh runjava.sh com.bdna.app.repository.DirectRepositoryConnection isPersistentStore`

if [ $IS_FACTBASE = "false" ]
then
   echo "Please run this script on FactBase schema!"| tee -a $LOG_FILE
   exit 2;
fi

# set db connect info
echo "[`date`] set the database connection." | tee -a $LOG_FILE
SKIPCRYPTO=`grep "^bdna.skipCrypto\s*.*=" $BDNA_HOME/conf/bdna.Linux.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`

USERNAME=`grep "^bdna.dbUser\s*.*=" $BDNA_HOME/conf/connection.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`
PASSWD=`grep "^bdna.dbPassword\s*.*=" $BDNA_HOME/conf/connection.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`
TNSDB=`grep "^bdna.dbServer\s*.*=" $BDNA_HOME/conf/connection.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`

if [[ x"$SKIPCRYPTO" == x"false" ]]
then
    PASSWD=`sh $BDNA_HOME/bin/runjava.sh com.bdna.ut.security.RunDecrypt $PASSWD`
fi

echo "[`date`] Check all pdbs and delete the wrong ones." | tee -a $LOG_FILE
sqlplus >> "${LOG_FILE}" << EOF
$USERNAME/$PASSWD@$TNSDB
@$CURRENT_DIR/delIncorrectDbs.sql
exit
EOF

sqlplus >> "${LOG_FILE}" << EOF
$USERNAME/$PASSWD@$TNSDB
select * from TMPBADPDBS;
drop table TMPBADPDBS;
commit;
exit
EOF

delPdbs=`grep '~' ./scripts.log|uniq`
echo "[`date`] The following wrong db names were deleted:" | tee -a $LOG_FILE
echo "$delPdbs" | tee -a $LOG_FILE
echo "[`date`] Done!" | tee -a $LOG_FILE
