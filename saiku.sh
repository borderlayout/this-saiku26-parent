#!/bin/bash

echo "begin to deploy saiku web app to tomcat ..."
tomcat_path="/opt/apache-tomcat-6.0.45"
tomcat_root_dir="${tomcat_path}/ROOT"
tomcat_root_war="${tomcat_path}/ROOT.war"

tomcat_app_dir="${tomcat_path}/saiku"
tomcat_app_war="${tomcat_path}/saiku.war"

tomcat_start_cmd="${tomcat_path}/bin/startup.sh"
tomcat_stop_cmd="${tomcat_path}/bin/shutdown.sh"

cur_path=`pwd`
#----------------------------
echo "Building saiku-core"
cd "${cur_path}"
cd saiku-core
call mvn install -Dmaven.test.skip=true

#---------------------------
echo "Building saiku-webapp ..."
cd "${cur_path}"
cd saiku-webapp
call mvn install  -Dmaven.test.skip=true 

#--------------------------
echo "Building saiku-ui  ... "
cd "${cur_path}"
cd saiku-ui
call mvn package install:install-file -Dfile=target/saiku-ui-2.6.1-SNAPSHOT.war  -DgroupId=org.saiku -DartifactId=saiku-ui -Dversion=2.6.1-SNAPSHOT -Dpackaging=war

#---------------------------
#echo "Building saiku-server"
#cd "${cur_path}"
#cd saiku
#cd saiku-server
#call mvn clean package  -Dmaven.test.skip=true 

#--------------------------
echo "stop tomcat ... "
call "${tomcat_stop_cmd}"

#------------------------------
echo "Deploying app to tomcat ... "
rm -rf "${tomcat_root_dir}"
rm -rf "${tomcat_app_dir}"
rm -f  "${tomcat_root_war}"
rm -f  "${tomcat_app_war}"

#saiku-ui-2.6.war修改成ROOT.war; saiku-webapp-2.6.war修改成saiku.war;拷贝两个war文件到tomcat/webapp
cd "${cur_path}"
cp "saiku-ui/target/saiku-ui-2.6-SNAPSHOT.war"  "${tomcat_root_war}"
cp "saiku-webapp/target/saiku-webapp-2.6.1-SNAPSHOT.war"  "${tomcat_app_war}"

#--------------------------
echo "start tomcat ... "
call "${tomcat_start_cmd}"

echo "end to deploy saiku."



