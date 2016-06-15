#!/bin/bash

echo "begin to deploy saiku web app to tomcat ..."
tomcat_path="/opt/apache-tomcat-6.0.45"
tomcat_root_dir="${tomcat_path}/webapps/ROOT"
tomcat_root_war="${tomcat_path}/webapps/ROOT.war"

tomcat_app_dir="${tomcat_path}/webapps/saiku"
tomcat_app_war="${tomcat_path}/webapps/saiku.war"

tomcat_start_cmd="${tomcat_path}/bin/startup.sh"
tomcat_stop_cmd="${tomcat_path}/bin/shutdown.sh"

tomcat_app_lib_path="${tomcat_path}/webapps/saiku/WEB-INF/lib"

#cur_path=`pwd`
saiku_path="/root/my_workspace/saiku-2.6.x"
#----------------------saiku core ------
echo "Building saiku-core"
cd "${saiku_path}"
cd saiku-core
mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true

#----------------------saiku webapp-----
echo "Building saiku-webapp ..."
cd "${saiku_path}"
cd "saiku-webapp"
mvn clean install  -Dmaven.test.skip=true -Dmaven.javadoc.skip=true

#-----------------------saiku ui---
echo "Building saiku-ui  ... "
cd "${saiku_path}"
cd "saiku-ui"
mvn clean package install:install-file -Dmaven.javadoc.skip=true -Dfile=target/saiku-ui-2.6.1-SNAPSHOT.war  -DgroupId=org.saiku -DartifactId=saiku-ui -Dversion=2.6.1-SNAPSHOT -Dpackaging=war

#-----------------------saiku server----
echo "Building saiku-server ..."
cd "${saiku_path}"
cd "saiku-server"
mvn clean package  -Dmaven.test.skip=true  -Dmaven.javadoc.skip=truels 

#------------cp example config file to data-sources--
echo "Deploying data source for saiku ... "
saiku_dest_datasource="${saiku_path}/saiku-webapp/target/saiku-webapp-2.6.1-SNAPSHOT/WEB-INF/classes/saiku-datasources"
saiku_src_datasource="${saiku_path}/cube_data"

cp -f ${saiku_src_datasource}/*  ${saiku_dest_datasource}

#---------------------sql4es compiler and deploy---------
echo "Build sql4es begin ...."
sql4es_path="${saiku_path}/sql4es-project"
sql4es_jar_path="${sql4es_path}/target/asql2es-1.0.1-jar-with-dependencies.jar"

saiku_webapp_target_path="${saiku_path}/saiku-webapp/target"
saiku_webapp_lib_path="${saiku_webapp_target_path}/saiku-webapp-2.6.1-SNAPSHOT/WEB-INF/lib"

# sql4es need jdk1.8 to compiler
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_91
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin

cd "${sql4es_path}"
mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true

export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_79
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin

cp -f "${sql4es_jar_path}"  "${saiku_webapp_lib_path}/"

echo "Build sql4es end ... "

#---------------------------
echo "Build webapp war ..."

cd "${saiku_webapp_target_path}"
rm -f saiku-webapp-2.6.1-SNAPSHOT.war

(cd "saiku-webapp-2.6.1-SNAPSHOT"; rm -f saiku-webapp-2.6.1-SNAPSHOT.war; jar -cf saiku-webapp-2.6.1-SNAPSHOT.war  *;  mv "saiku-webapp-2.6.1-SNAPSHOT.war" "${saiku_webapp_target_path}/")


#--------------------------
echo "stop tomcat ... "
${tomcat_stop_cmd}

#------------------------------
echo "Deploying app to tomcat ... "
rm -rf "${tomcat_root_dir}"
rm -rf "${tomcat_app_dir}"
rm -f  "${tomcat_root_war}"
rm -f  "${tomcat_app_war}"

#saiku-ui-2.6.war修改成ROOT.war; saiku-webapp-2.6.war修改成saiku.war;拷贝两个war文件到tomcat/webapp
cd "${saiku_path}"
echo "copy saiku-ui-2.6.1-SNAPSHOT.war to ${tomcat_root_war} ..."
cp "saiku-ui/target/saiku-ui-2.6.1-SNAPSHOT.war"  "${tomcat_root_war}"

echo "copy saiku-webapp-2.6.1-SNAPSHOT.war to ${tomcat_app_war} ..."
cp "saiku-webapp/target/saiku-webapp-2.6.1-SNAPSHOT.war"  "${tomcat_app_war}"

# tomcat and sql4es need jdk1.8 to start
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_91
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin

#add <Manager className="org.apache.catalina.session.PersistentManager" saveOnRestart="false"/> for web app for saiku service
#--------------------------
echo "start tomcat ... "
${tomcat_start_cmd}

echo "end to deploy saiku."



