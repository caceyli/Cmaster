Here is the function and instruction for the script:
----------
FUNCTION
----------
1. This script is running on factbase server and working against the imported cs that hasn't been linked or built report.
2. This script can create a new cs based on specific networks from the imported cs that includes all networks.
3. The cs created by this script is as same as the one exported with 'expcoll -c' if there is no duplicate ips existing.
4. Handle with the duplicate ips. (The duplicate ips means the ones that eixst in more than one networks. For example: IP_A belongs to network_A and network_B, 'expcoll -c' will delete this ip if the included networks only includes either of them, but this script will keep it so that no data lost.)
-----------
INSTRUCTION
-----------
1. import the collection that includes whole networks with command 'impcoll' in factbase server as usually did under bdna shell. (eg: the name of imported cs is "2017-04-24-discover")
2. Don't add "2017-04-24-discover" to any inventory.
3. cp the script package 'FbFiltcoll.zip' to $BDNA_HOME and unzip it: unzip -o FbFiltcoll.zip.
4. creat an includeFile with element_full_name of specific  netwok. (example network: root.$bdna.NS_GLOBAL.network_IT)
4. cd to the dir $$BDNA_HOME/FbFiltcoll and run the script:
sh ./FbImpcoll.sh <-c includeFile> <-n csNameForSpecificNet> <-a csNameForAllNet>
(eg: sh FbImpcoll.sh -c /tmp/includefile -n IT -a 2017-04-24-discover)
5. A new collection "IT" will be created in factbased schema if the above script command is completed without error.
6. Add the new collection to any inventory you want and then refresh the report as usual.

--------
USAGE
--------
FbFiltcoll.sh -  Shell script to get collection based on specific networks.

Usage: FbFiltcoll.sh <-c includeFile> <-n csNameForSpecificNet> <-a csNameForAllNet>
where:
<-c inclusionFileName> include a list of networks, along with all of the
content belonging to them. A valid includeFile will have one ELEMENT_FULL_NAME
per line for each network to be included. See the File Examples section for a
sample inclusion file entry.
<-n csNameForSpecificNet> Name for the collection that only includes the
networks definded in inclusion file.
<-a csNameForAllNet> Name for the collection that includes all network and has
been imported into factbase.

EXAMPLES:
sh FbImpcoll.sh -c /tmp/includefile -n IT -a 2017-04-24-discover

FILE EXAMPLE1 (one network):
Include File:
root.$bdna.NS_GLOBAL.network_IT

FILE EXAMPLE1 (multiple networks):
Include File:
root.$bdna.NS_GLOBAL.network_IT
root.$bdna.NS_GLOBAL.network_ITVC

---------
NOTE
---------
1. Run this script once, you can get a new cs in factbase server already, no need to impcoll again. you can check whether this new cs produced successfully or not by running commands:
a. sh bdna.sh
b. lscoll -l -a
2. Before building the report, you can run the script as many times as you want to get different new cs based on networks from the original cs that includes all networks. But if you want to get another new cs from the same original cs after running snapshot or refresh commands, you should re-import the original cs that includes all networks, then run the script.
