cp /home/bdna/560/newbuilds/* /home/bdna/src/bdna/build
cp /home/bdna/560/newlibs/* /home/bdna/src/bdna/nih/Tomcat/lib
sed -i "s/tomcat-8.0.23/tomcat-8.5.32/g" `grep -rl 'tomcat-8.0.23' /home/bdna/src/bdna` 2>/dev/null
sed -i "s/tomcat-8.5.29/tomcat-8.5.32/g" `grep -rl 'tomcat-8.5.29' /home/bdna/src/bdna` 2>/dev/null
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/lib/tomcat-api.jar /home/bdna/src/bdna/nih/Tomcat/lib
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/lib/tomcat-coyote.jar /home/bdna/src/bdna/nih/Tomcat/lib
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/lib/tomcat-jni.jar /home/bdna/src/bdna/nih/Tomcat/lib
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/bin/tomcat-juli.jar /home/bdna/src/bdna/nih/Tomcat/lib
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/lib/tomcat-util-scan.jar /home/bdna/src/bdna/nih/Tomcat/lib
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/lib/tomcat-util.jar /home/bdna/src/bdna/nih/Tomcat/lib
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/bin/bootstrap.jar /home/bdna/src/bdna/nih/Tomcat
cp /home/bdna/src/bdna/nih/Tomcat/apache-tomcat-8.5.32/lib/catalina.jar  /home/bdna/src/bdna/nih/Tomcat/lib
cp nih/Tomcat/apache-tomcat-8.5.32/lib/annotations-api.jar /home/bdna/src/bdna/nih/Tomcat/lib/
cp nih/Tomcat/apache-tomcat-8.5.32/lib/jasper.jar /home/bdna/src/bdna/nih/Tomcat/lib/
cp nih/Tomcat/apache-tomcat-8.5.32/lib/jsp-api.jar /home/bdna/src/bdna/nih/Tomcat/lib/
cp nih/Tomcat/apache-tomcat-8.5.32/lib/servlet-api.jar /home/bdna/src/bdna/nih/Tomcat/lib/
cd /home/bdna/src/bdna/
rm -f .git/index
git reset
