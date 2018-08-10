DESCRIPTION

This is a hotfix for BDNA-28885 and BDNA-28863, it is only for intended to use with Discover 7.7.2 GA.
The version for this hofix is: BDNA version 7.7.2 GA, Build 4100(2018_03_30_22_55)

This hotfix contains the package "hotfix_BDNA-28885_Tomcat8529.zip" and  and is used for 
1. Upgrading Apache Tomcat/8.0.23 or Tomcat/8.5.15 to Apache Tomcat/8.5.15 when using Discover 7.7.2 GA.
2. Delete common uploadFile 1.3.1.

"hotfix_BDNA-28885_28863.zip" contains two files:
1. BDNA-28885_Tomcat8529.zip (includes the libraries for tomcat 8.5.29)
2. configuration file for this hotfix. (cfgHotfix.sh)

PURPOSE
This hotfix is intended to upgrade Apache Tomcat/8.0.23 or Tomcat/8.5.15 to Apache Tomcat/8.5.29 for Discover 7.7.2 GA and delete common uploadFile 1.3.1.

INSTRUCTIONS 

To apply this hotfix on new Collection Store or Factbase installation:

1)  Install the Discover Platform 7.7.2 GA.
2)  Transfer hotfix_BDNA-28885_28863.zip to the Discover server. For example, /tmp.
3)  Type cp /tmp/hotfix_BDNA-28885_28863.zip  $BDNA_HOME/ .
4)  Type cd $BDNA_HOME .
5)  Type unzip -o hotfix_BDNA-28885_28863.zip.
6)  Type cd hotfix_BDNA-28885_28863
7)  Type sh cfgHotfix.sh .
8)  Load the Enterprise sequence for the Collection Store/Factbase.
9)  After BDNA starts up, check $BDNA_HOME/logs/controlOut.log to see that Apache Tomcat/8.5.29 has started, and build number has changed to BDNA version 7.7.2 GA, Build 4100(2018_03_30_22_55).
10)  Confirm there is no 'commons-fileupload-1.3.1.jar' and class 'com/bdna/cts/NotifierServlet.class' under $BDNA_HOME/lib
a. grep -r NotifierServlet.class $BDNA_HOME/lib/ 
b. find $BDNA_HOME/lib/ -name commons-fileupload-1.3.1.jar
c. The above command should return nothing.

To apply the hotfix on an existing Collection Store installation:

Note:  Since this procedure involves "initdb", please export credentials, networks...etc via Discover UI > Scan Administration > Scan Setup now.  

1)  Transfer hotfix_BDNA-28885_28863.zip to Discover server. For example, /tmp.
2)  Type cp /tmp/hotfix_BDNA-28885_28863.zip  $BDNA_HOME/ .
3)  Type cd $BDNA_HOME (where Discover 7.7.2 GA has been installed). 
4)  Shutdown Discover, that is

cd $BDNA_HOME/bin
bdna> sh ./bdna.sh
bdna> shutdown
bdna> exit
killall -9 java perl

5)  Type unzip -o hotfix_BDNA-28885_28863.zip .
6)  Type cd hotfix_BDNA-28885_28863
7)  Type sh cfgHotfix.sh
8)  Startup BDNA agent, that is:

sh $BDNA_HOME/bin/startagent.sh &

9)   Type sh $BDNA_HOME/bin/bdna.sh 
10)  To initialize the BDNA schema, run the command: bdna> initdb .
11)  Type bdna> startup .
12)  After BDNA starts up, check $BDNA_HOME/logs/controlOut.log to see that Apache Tomcat/8.5.29 has started, and build number has changed to BDNA version 7.7.2 GA, Build 4100(2018_03_30_22_55).
13)  After startup, bring up  Discover Server UI as username and password below:
14)  Confirm there is no 'commons-fileupload-1.3.1.jar' and class 'com/bdna/cts/NotifierServlet.class' under $BDNA_HOME/lib
a. grep -r NotifierServlet.class $BDNA_HOME/lib/
b. find $BDNA_HOME/lib/ -name commons-fileupload-1.3.1.jar
c. The above command should return nothing.

Username: root
Password: password

Note:  initdb reset Discover UI password back to default.

15) Once login to Discover UI, go to Application Administration > User and Role Management > User.
      Open "User root" , click [Edit].  now you could reset password to your choice.

To apply the hotfix for an existing Factbase installation:

1)  Transfer  to the Discover server. .For example, /tmp.
2)  Type cp /tmp/hotfix_BDNA-28885_28863.zip  $BDNA_HOME/ .
3)  Type cd $BDNA_HOME (where Discover 7.7.2 GA have been installed). 
4)  Shutdown Discover, that is

cd $BDNA_HOME/bin
bdna> sh ./bdna.sh
bdna> shutdown
bdna> exit
killall -9 java perl

5)  Type unzip -o hotfix_BDNA-28885_28863.zip .
6)  Type cd hotfix_BDNA-28885_28863
7)  Type sh cfgHotfix.sh .
8)  Startup BDNA agent, that is:

sh $BDNA_HOME/bin/startagent.sh &

9)  Type sh $BDNA_HOME/bin/bdna.sh
10) To start up the BDNA schema, run the command: bdna> startup .
11) After BDNA starts up, check $BDNA_HOME/logs/controlOut.log to see that Apache Tomcat/8.5.15 starts up normally.
12) Please use "root/[your password]" to bring up the Discover Server UI after startup, and build number has changed to BDNA version 7.7.2 GA, Build 4100(2018_03_30_22_55).
13) Confirm there is no 'commons-fileupload-1.3.1.jar' and class 'com/bdna/cts/NotifierServlet.class' under $BDNA_HOME/lib
a. grep -r NotifierServlet.class $BDNA_HOME/lib/
b. find $BDNA_HOME/lib/ -name commons-fileupload-1.3.1.jar
c. The above command should return nothing.

