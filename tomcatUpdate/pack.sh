#!/bin/bash

cd hotfix_BDNA-30390/BDNA-30390_Tomcat8532
zip -p -r BDNA-30390_Tomcat8532.zip ./*
mv BDNA-30390_Tomcat8532.zip ../
cd ../../
rm -rf ./hotfix_BDNA-30390/BDNA-30390_Tomcat8532
zip -p -r hotfix_BDNA-30390.zip hotfix_BDNA-30390
rm -rf hotfix_BDNA-30390
