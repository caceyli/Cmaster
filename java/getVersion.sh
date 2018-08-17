#!/bin/bash
export JAVA_HOME=/usr/java/jdk1.8.0_05
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

if [ -f $BDNA_HOME/nih/Tomcat/apache-tomcat-8.5.32/lib/batik-util.jar ]; then
  `java -cp $CLASSPATH:$BDNA_HOME/nih/Tomcat/apache-tomcat-8.5.32/lib/batik-util.jar getBatikVersion`
else
  echo "no batik installed in $BDNA_HOME"
fi

source /home/bdna/.bash_profile
