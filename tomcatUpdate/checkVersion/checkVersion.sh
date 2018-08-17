#!/bin/bash
tomcatVersion=`cat $BDNA_HOME/bin/setbdnacp.sh | grep CATALINA_HOME= | sed -rn "s/CATALINA_HOME=.*Tomcat\///gp"`
chmod a+x $BDNA_HOME/nih/Tomcat/$tomcatVersion/bin/catalina.sh
echo "##########check tomcat#########"
sh $BDNA_HOME/nih/Tomcat/$tomcatVersion/bin/version.sh
chmod a-x $BDNA_HOME/nih/Tomcat/$tomcatVersion/bin/catalina.sh

export JAVA_HOME=/usr/java/jdk1.8.0_05
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

if [ -f $BDNA_HOME/nih/Tomcat/$tomcatVersion/lib/batik-util.jar ]; then
  echo "##########check batik#########"
  java -cp $CLASSPATH:$BDNA_HOME/nih/Tomcat/$tomcatVersion/lib/batik-util.jar getBatikVersion
else
  echo "##########check batik#########"
  echo "no batik installed in $BDNA_HOME"
fi
source /home/bdna/.bash_profile >/dev/null
