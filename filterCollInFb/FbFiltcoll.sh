#!/bin/sh

#LOG_FILE=$BDNA_HOME/logs/csFilterOutput.log

print_usage()
{
    echo ""
    echo "FbFiltcoll.sh -  Shell script to get collection based on specific networks."
    echo ""
    echo "Note: This script only works on FactBase Schema."
    echo "Usage: FbFiltcoll.sh <-c includeFile> <-n csNameForSpecificNet> <-a csNameForAllNet>"
    echo "where:"
    echo "<-c inclusionFileName> include a list of networks, along with all of the content belonging to them. A valid includeFile will have one ELEMENT_FULL_NAME per line for each network to be included. See the File Examples section for a sample inclusion file entry."
    echo "<-n csNameForSpecificNet> Name for the collection that only includes the networks definded in inclusion file."
    echo "<-a csNameForAllNet> Name for the collection that includes all network and has been imported into factbase."
    echo ""
    echo "EXAMPLES:"
    echo "sh FbFiltcoll.sh -c /tmp/includefile -n IT -a 2017-04-24-discover"
    echo ""
    echo "FILE EXAMPLES:"
    echo ""
    echo "Include File:"
    echo "root.\$bdna.NS_GLOBAL.network_IT"
    echo ""
    exit 1
}

while getopts "c:n:a:h" opt
do
    case $opt in
    c) includeFile=$OPTARG;;
    n) newCsName=$OPTARG;;
    a) allCsName=$OPTARG;;
    f) TARGET_DIR=$OPTARG;;
    i) INVENTORY=$OPTARG;;
    h) print_usage ; exit 0;;
    *) print_usage ; exit 1;;
    esac
done

if [ "x$TARGET_DIR" == "x" ]
then
   TARGET_DIR=`pwd`
fi

if [ "$#" -lt 3 ]
then
  print_usage
  exit 2;
fi

LOG_FILE=$TARGET_DIR/FbFiltcollOutput.log

# check whether it is a FactBase schema
echo "[`date`] Checking if the schema is a FactBase schema." | tee -a $INVLOG
IS_FACTBASE=`sh runjava.sh com.bdna.app.repository.DirectRepositoryConnection isPersistentStore`

NOW=`date '+%Y%m%d'`

if [ $IS_FACTBASE = "false" ]
then
   echo "This is not a FactBase Schema!"| tee -a $LOG_FILE
   exit 2;
fi

if [ $IS_FACTBASE = "true" ]
then
   while ([ "x$allCsName" == "x" ])
   do
       print_usage;
       exit 2;
#      read -r -p "Please enter the csNameForAllNet that is to be filtered by specific network: " allCsName
   done
fi


SKIPCRYPTO=`grep "^bdna.skipCrypto\s*.*=" $BDNA_HOME/conf/bdna.Linux.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`

# set db connect info
USERNAME=`grep "^bdna.dbUser\s*.*=" $BDNA_HOME/conf/connection.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`
PASSWD=`grep "^bdna.dbPassword\s*.*=" $BDNA_HOME/conf/connection.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`
TNSDB=`grep "^bdna.dbServer\s*.*=" $BDNA_HOME/conf/connection.properties | tail -1 | gawk -F"=" '{print $2}' | gawk '{print $1}'`

if [[ x"$SKIPCRYPTO" == x"false" ]]
then
    PASSWD=`sh $BDNA_HOME/bin/runjava.sh com.bdna.ut.security.RunDecrypt $PASSWD`
fi

if [ $IS_FACTBASE = "true" ]
then
sqlplus > tempsqlresult << EOF
$USERNAME/$PASSWD@$TNSDB
select 'id=', trim(id) from local_scan where name = '${allCsName}';
exit;
EOF
fi

lsid=`grep "^id=" tempsqlresult | gawk -F"= " '{print $2}'`
#echo "$lsid"

rm tempsqlresult

if [ "x$includeFile" == "x" ]
then
     print_usage
     exit 2;
fi

echo "included networks:"
count=0
while read line
do
echo "$line"
count=$(($count+1))
if test $count -eq 1
then
    includeNets="$line"
else
    includeNets="$includeNets'',''$line"
fi
done < $includeFile
includeNets="$includeNets"
#echo "$includeNets"

echo "[`date`] Generating table element_gragh." | tee -a $LOG_FILE
sqlplus >> "${LOG_FILE}" << EOF
$USERNAME/$PASSWD@$TNSDB
@$TARGET_DIR/createElementGraphTable.sql $lsid
exit
EOF

echo "[`date`] create new cs '$newCsName' based on specific network." | tee -a $LOG_FILE
sqlplus >> "${LOG_FILE}" << EOF
$USERNAME/$PASSWD@$TNSDB
@$TARGET_DIR/createNewLsTable.sql $lsid $includeNets $newCsName
exit
EOF

echo "done!"
