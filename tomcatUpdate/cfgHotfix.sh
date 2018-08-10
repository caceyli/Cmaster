#!/bin/bash
currDir=`pwd`
#check BDNA version
echo -e "Step (1/4) check BDNA version."
bdnaPropFile=`echo $BDNA_HOME/conf/bdna.Linux.properties`
bdnaVersion=`eval "cat $bdnaPropFile | sed -rn "s/.*bdna.version=//gp""`
bdnaBuildNumber=`eval "cat $bdnaPropFile | sed -rn "s/.*bdna.build.number=//gp""`
bdnaBuild=`eval "cat $bdnaPropFile | sed -rn "s/.*bdna.build=//gp""`
releaseVersion=`eval "cat $bdnaPropFile | sed -rn "s/.*releaseVersion=//gp""`
buildNumber=`eval "cat $bdnaPropFile | sed -rn "s/.*content.build.number=//gp""`
skipCrypto=`eval "cat $bdnaPropFile | sed -rn "s/bdna.skipCrypto//gp""`
branch=`eval "cat $bdnaPropFile | sed -rn "s/bdna.release=//gp""`
hotfix22735=`eval "cat $BDNA_HOME/conf/mbus.properties|grep 'glue'"`

oldTomcatVersion=`cat $BDNA_HOME/bin/setbdnacp.sh | grep CATALINA_HOME= | sed -rn "s/CATALINA_HOME=.*Tomcat\///gp"`

if [ $bdnaBuildNumber == 4096 ];then
  appliedHotfix="hotfix_BDNA-17842_Tomcat8515.zip"
  if [ -z $hotfix22735 ];then
    appliedHotfix="hotfix_BDNA-22735.zip, "$appliedHotfix
  fi
  echo "Server: BDNA version $bdnaVersion $branch, Build $bdnaBuildNumber($bdnaBuild)"
  echo "Tomcat: $oldTomcatVersion"
  echo "Apllied Platform Hotfix: $appliedHotfix"
  #update permmission
  `rm -rf $BDNA_HOME/bin/suspend* 2>/dev/null`
  `sudo chmod 664 $BDNA_HOME/bin/setbdnacp.sh`
  `sudo chmod 664 $BDNA_HOME/bin/configure.sh`
  uid=`id| awk '{print $1}'|sed -rn "s/.*\((.*)\)/\1/gp"`
  gid=`id| awk '{print $2}'|sed -rn "s/.*\((.*)\)/\1/gp"`
  `sudo chown $uid:$gid $BDNA_HOME/bin/setbdnacp.sh`
  `sudo chown $uid:$gid $BDNA_HOME/bin/configure.sh`
elif [ $bdnaBuildNumber == 4100 ];then
  appliedHotfix="hotfix_BDNA-28885_28863.zip"
  if [ -z $hotfix22735 ];then
    appliedHotfix="hotfix_BDNA-22735.zip, "$appliedHotfix
  fi
  echo "Server: BDNA version $bdnaVersion $branch, Build $bdnaBuildNumber($bdnaBuild)"
  echo "Tomcat: $oldTomcatVersion"
  echo "Apllied Platform Hotfix: $appliedHotfix"
elif [ $bdnaBuildNumber == 4101 ];then
  appliedHotfix="hotfix_BDNA-30390.zip"
  if [ -z $hotfix22735 ];then
    appliedHotfix="hotfix_BDNA-22735.zip, "$appliedHotfix
  fi
  echo "Server: BDNA version $bdnaVersion $branch, Build $bdnaBuildNumber($bdnaBuild)"
  echo "Tomcat: $oldTomcatVersion"
  echo "Apllied Platform Hotfix: $appliedHotfix"
  echo "This server already includes the hotfix 'hotfix_BDNA-30390.zip', exiting......"
  echo "Done!"
  exit 0
else
  if [ -z $hotfix22735 ];then
    appliedHotfix="hotfix_BDNA-22735.zip"
  else
    appliedHotfix="none"
  fi
  echo "Server: BDNA version $bdnaVersion $branch, Build $bdnaBuildNumber($bdnaBuild)"
  echo "Tomcat: $oldTomcatVersion"
  echo "Apllied Platform Hotfix: $appliedHotfix"
fi

#get BDNA configuration file for tomcat upgrade
echo -e "Step (2/4) get BDNA configuration."
bdnaCfgFile=`echo $BDNA_HOME/bin/configure.sh`
bdnaTomcat=`echo $BDNA_HOME/nih/Tomcat`
oldHttpConfFile=`echo $BDNA_HOME/nih/Tomcat/$oldTomcatVersion/conf/server.xml`
newHttpConfFile=`echo $BDNA_HOME/nih/Tomcat/apache-tomcat-8.5.32/conf/server.xml`

#get existing tomcat web configuration
httpConnPort=`eval "cat $oldHttpConfFile | grep -E 'port.*75' | sed -rn "s/.*port\=//gp" | sed -rn "s/min.*//gp""`
port=`echo "$httpConnPort"| sed -rn "s/[ \"]//gp"`

#regrex for update configure files
regex_newTomcatVersion="\"s/$oldTomcatVersion/apache-tomcat-8.5.32/g\""
regex_release="\"s/BDNA_CONTENT_RELEASE_VERSION/$releaseVersion/g\""
regex_buildNumber="\"s/BDNA_CONTENT_BUILD_NUMBER/$buildNumber/g\""
regex_skipCrypto="\"s/bdna.skipCrypto.*/bdna.skipCrypto$skipCrypto/g\""
regex_httpConnPort="\"s/8080/$port/g\""

#unzip package tomcat 8.5.29 files to $BDNA_HOME
echo -e "Step (3/4) unzip package tomcat 8.5.32 files to $BDNA_HOME."
unzip -o $BDNA_HOME/hotfix_BDNA-30390/BDNA-30390_Tomcat8532.zip -d $BDNA_HOME >$BDNA_HOME/logs/hotfix.log

#update BDNA configuration
echo -e "Step (4/4) update BDNA configuration."
`eval "sed -i -e $regex_newTomcatVersion $bdnaCfgFile 2>/dev/null"`
`eval "sed -i -e $regex_release $bdnaPropFile 2>/dev/null"`
`eval "sed -i -e $regex_buildNumber $bdnaPropFile 2>/dev/null"`
`eval "sed -i -e $regex_skipCrypto $bdnaPropFile 2>/dev/null"`
`eval "sed -i -e $regex_httpConnPort $newHttpConfFile 2>/dev/null"`

chmod a+x $BDNA_HOME/nih/jdk/bin/jar
#update class in bdna.jar for tomcat upgrade.
cd $BDNA_HOME/lib/bdna
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/clm/CLMConfig.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/clm/CLMConfig$1.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/clm/ICLMConfig.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/pl/util/Catalina.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/pl/defaults/ServiceDefaults.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/pl/admin/util/AdminCatalina.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/pl/replay/FrontendReplay.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna.jar com/bdna/control/command/CommandInitFB.class 

#update class in bdna_g.jar for tomcat upgrade.
cd $BDNA_HOME/lib/bdna_g
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/clm/CLMConfig.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/clm/CLMConfig$1.class
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/clm/ICLMConfig.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/pl/util/Catalina.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/pl/defaults/ServiceDefaults.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/pl/admin/util/AdminCatalina.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/pl/replay/FrontendReplay.class 
$BDNA_HOME/nih/jdk/bin/jar -uf $BDNA_HOME/lib/bdna_g.jar com/bdna/control/command/CommandInitFB.class 

#clean the tmp files.
echo "The hotfix hotfix_BDNA-30390.zip applied successfully, remove tmp files."
echo "Please restart BDNA Server to apply the hotfix. (initdb is only required for an existing BDNA Collection Server)"
rm -rf $BDNA_HOME/lib/bdna $BDNA_HOME/lib/bdna_g 2>/dev/null
if [ "$oldTomcatVersion"x != "apache-tomcat-8.5.32"x ]; then
  rm -rf $BDNA_HOME/nih/Tomcat/$oldTomcatVersion* 2>/dev/null
fi
echo "Done!"
exit 0
