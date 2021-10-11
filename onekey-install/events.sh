#!/bin/bash
#
# create 2021/08/23  by suhuihuang



# install yujing module
tar xf action_prediction.tar.gz -C /app/biaozhu/
cp /app/conf/python/predic.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable predic.service
systemctl start predic.service

# install mysql 5.7
flush privileges;
grant all  privileges on *.* to 'root'@'%' identified by 'root' with grant option;
flush privileges;
create database shijianqiang;
mysql -uroot -proot shijianqiang < shijianqiang.sql

# install elasticsearch 5.6.1
useradd pdl
cd /app/soft
tar xf elasticsearch-5.6.1.tar.gz -C /app/biaozhu/
chown -R pdl.pdl /app/biaozhu
cp /app/conf/elasticsearch/elasticsearch.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# install Tomcat
cd /app/soft
tar xf apache-tomcat-7.0.47.tar.gz -C /app/biaozhu/
IP=`ip a|grep enp|grep inet|awk -F '[ /]' '{print $6}'`
sed -i s#10.107.17.70#$IP#g  /app/biaozhu/apache-tomcat-7.0.47/webapps/event-anno/resource/httpRequest.js
sed -i s#10.107.17.70#$IP#g  /app/biaozhu/apache-tomcat-7.0.47/webapps/event-anno/views/event-wall/app.a9ed35ad.js
chown -R pdl.pdl /app/biaozhu
cp /app/conf/tomcat/tomcat.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable tomcat.service
systemctl start tomcat-service



# install zlxsfs
cp /app/soft/zlxsfs-0.0.1-SNAPSHOT.jar /app/biaozhu/




