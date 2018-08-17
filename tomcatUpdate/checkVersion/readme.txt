This script is used to help checkout the version of Tomcat and batik for BDNA
discover.

USAGE:
sh checkVersion.sh

java -classpath $CLASSPATH:batik-util.jar getBatikVersion
Batik Version:
 batik-1_5

example output before fix:
##########check tomcat#########
Using CATALINA_BASE:   /home/bdna/install772/nih/Tomcat/apache-tomcat-8.0.23
Using CATALINA_HOME:   /home/bdna/install772/nih/Tomcat/apache-tomcat-8.0.23
Using CATALINA_TMPDIR:
/home/bdna/install772/nih/Tomcat/apache-tomcat-8.0.23/temp
Using JRE_HOME:        /usr/java/jdk1.8.0_05/jre
Using CLASSPATH:
/home/bdna/install772/nih/Tomcat/apache-tomcat-8.0.23/bin/bootstrap.jar:/home/bdna/install772/nih/Tomcat/apache-tomcat-8.0.23/bin/tomcat-juli.jar
Server version: Apache Tomcat/8.0.23
Server built:   May 19 2015 14:58:38 UTC
Server number:  8.0.23.0
OS Name:        Linux
OS Version:     2.6.32-431.el6.x86_64
Architecture:   amd64
JVM Version:    1.8.0_05-b13
JVM Vendor:     Oracle Corporation
##########check batik#########
Batik Version:
 batik-1_5

example output after fix:
##########check tomcat#########
Using CATALINA_BASE:   /home/bdna/install772/nih/Tomcat/apache-tomcat-8.5.32
Using CATALINA_HOME:   /home/bdna/install772/nih/Tomcat/apache-tomcat-8.5.32
Using CATALINA_TMPDIR:
/home/bdna/install772/nih/Tomcat/apache-tomcat-8.5.32/temp
Using JRE_HOME:        /usr/java/jdk1.8.0_05/jre
Using CLASSPATH:
/home/bdna/install772/nih/Tomcat/apache-tomcat-8.5.32/bin/bootstrap.jar:/home/bdna/install772/nih/Tomcat/apache-tomcat-8.5.32/bin/tomcat-juli.jar
Server version: Apache Tomcat/8.5.32
Server built:   Jun 20 2018 19:50:35 UTC
Server number:  8.5.32.0
OS Name:        Linux
OS Version:     2.6.32-431.el6.x86_64
Architecture:   amd64
JVM Version:    1.8.0_05-b13
JVM Vendor:     Oracle Corporation
##########check batik#########
no batik installed in /home/bdna/install772

