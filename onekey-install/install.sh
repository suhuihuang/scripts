#!/bin/bash

# create 2021/08/23 by suhuihuang

username=kylin

public=/app/public
biaozhu=/app/biaozhu
soft=/app/soft
conf=/app/conf
biaozhu=/app/biaozhu


if [ ! -d "$public" ];then
	mkdir -p $public
fi

if [ ! -d "$biaozhu" ];then
	mkdir -p $biaozhu
fi


# 判断 kyin 是否存在
if id $username >/dev/null 2>&1;then
	#echo $username  exits!
	chown -R $username.$username /app
else
	username
	exit 0;
fi



# 判断当前为 $username 用户
#if [[ $(whoami) == $username ]];then
#	echo $username user！
#else
#	echo Currently the `whoami` user, Switching $username user!
#	su - $username
#	exit 0
#fi


usage() {
	echo "Usage: install  [anaconda|nginx|jdk|mysql|pytorch|tensorflow|elasticsearch|neo4j|biaozhu]"
}

# type java    判断软件是否安装

username() {
	echo create username $username ....
	adduser $username;
	echo $username:123456 |chpasswd;
	echo $username user  create success!
	chown -R $username.$username /app
}

aconda() {
	source /app/public/archiconda3/etc/profile.d/conda.sh >/dev/null 2>&1
	if type conda >/dev/null 2>&1;then
		echo Anaconda already installed!
	else
		tar xf /app/soft/archiconda3.tar.gz -C /app/public/
		sed -i  '1c #!/app/public/archiconda3/bin/python' /app/public/archiconda3/bin/conda
		sed -i  '1c #!/app/public/archiconda3/bin/python' /app/public/archiconda3/bin/conda-env
		sed -i  '1c _CONDA_EXE="/app/public/archiconda3/bin/conda"' /app/public/archiconda3/etc/profile.d/conda.sh
		sed -i  '2c _CONDA_ROOT="/app/public/archiconda3"' /app/public/archiconda3/etc/profile.d/conda.sh
		sed -i  '1c _CONDA_EXE="/app/public/archiconda3/bin/conda"' /app/public/archiconda3/etc/profile.d/conda.csh
		sed -i  '2c _CONDA_ROOT="/app/public/archiconda3"' /app/public/archiconda3/etc/profile.d/conda.csh
		sed -i  '1c set _CONDA_EXE "/app/public/archiconda3/bin/conda"' /app/public/archiconda3/etc/fish/conf.d/conda.fish
		sed -i  '2c set _CONDA_ROOT "/app/public/archiconda3"' /app/public/archiconda3/etc/fish/conf.d/conda.fish
		echo Anaconda install success!
	fi
	#echo activation python 3.6, please run \"source /app/scripts/activate_py36.sh\".
	#echo activation python 3.7, please run \"source /app/scripts/activate_py37.sh\"
}
	
ngx() {
	if type nginx >/dev/null 2>&1;then
		echo nginx already installed!
	else
		cd /app/soft
		tar xf nginx1.18_linux_arm.tar.gz -C /app/public
		ln -sf /app/public/nginx1.18/sbin/nginx /usr/local/sbin/nginx
		cp /app/conf/nginx/nginx.conf /app/public/nginx1.18/conf/nginx.conf
		cp /app/conf/nginx/nginx.service /lib/systemd/system/nginx.service
		systemctl daemon-reload 
		systemctl enable nginx.service
		systemctl restart nginx.service
	fi

	http_code=`curl -I 127.0.0.1 | awk 'NR==1{print $2}'` >/dev/null 2>&1
	if  [ $http_code == 200 ];then
		echo  nginx access successful!
	fi
}

jdk() {
	if type java >/dev/null 2>&1;then
		echo JDK already installed!
	else
		cd /app/soft
		tar xf jdk-8u271-linux-aarch64.tar.gz -C /app/public/
		sed -i.ori '$a export JAVA_HOME=/app/public/jdk1.8.0_271\nexport PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH\nexport CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar' /etc/profile
		echo JDK install ok! 
		echo Please run  \"source /etc/profile\"
	fi
}

msql() {
	#apt-get update >/dev/null 2>&1
	apt-get install mysql-server -y >/dev/null 2>&1
	if ! grep -w skip-grant-tables /etc/mysql/mysql.conf.d/mysqld.cnf;then
		sed -i '39a skip-grant-tables' /etc/mysql/mysql.conf.d/mysqld.cnf
		sed -i "s%bind-address%#bind-address%g" /etc/mysql/mysql.conf.d/mysqld.cnf
	fi

	systemctl enable mysql  >/dev/null 2>&1
	systemctl restart mysql 

	if netstat -lntup | grep mysql;then
		echo MySQL Startup Success!
		mysql -e "use mysql;update user set authentication_string='root' where user='root' and host='localhost';"
		mysql -e "flush privileges;"
		systemctl restart mysql
	else
		echo MySQL Startup Failed!
	fi

	if mysql -uroot -proot -h127.0.0.1 -e "show databases;";then
		echo MySQL user authorization succeeded!
	else
		echo MySQL user authorization failed!
		echo Please check then reason!
	fi
}

torch() {
	if [ -d /app/public/pytorch1.7.0-py36 ];then
		echo already installed!
	else
		cd /app/soft/
		tar xf pytorch.tgz -C /app/public/
		tar xf openblas.tgz -C /app/public/
		\cp /app/public/pytorch1.7.0-py36/lib/libstdc++.so.6.0.28 /app/public/archiconda3/envs/test/lib/libstdc++.so.6
		echo pytorch install success!
	fi
	echo Please run \"source /app/scripts/start_pytorch.sh\", import pytorch environment!
}

tenflow() {
	if [ -d /app/public/tensorflow1.13.1-py36 ];then	
		echo already installed!
	else
		cd /app/soft
		tar xf tensorflow.tgz -C /app/public/
		echo tensorflow install success!
	fi
	echo Please run \"source /app/scripts/start_tensorflow.sh\", load tensorflow environment!
}

es() {
	jdk
	if [ -d /app/biaozhu/elasticsearch-5.6.1 ];then
		echo ElasticSearch already installed!
	else
		cd /app/soft/
		tar xf elasticsearch-5.6.1.tar.gz -C /app/biaozhu/
		chown -R $username.$username /app
		cp /app/conf/elasticsearch/elasticsearch.service /lib/systemd/system/
		sed -i "s%User=pdl%User=$username%g" /lib/systemd/system/elasticsearch.service
		sed -i "s%Group=pdl%Group=$username%g" /lib/systemd/system/elasticsearch.service
		if ! sysctl -p | grep -w "vm.max_map_count = 262144";then
			echo "vm.max_map_count = 262144" >>/etc/sysctl.conf;
			#echo "*  soft  nofile  65536" >>/etc/security/limits.conf
			#echo "*  hard  nofile  65536" >>/etc/security/limits.conf
			sysctl -p >/dev/null 2>&1;
		fi
		
		systemctl daemon-reload
		systemctl enable elasticsearch.service
		systemctl restart elasticsearch.service
	fi

	if systemctl status elasticsearch|grep Active|awk '{print $2}' >/dev/null 2>&1;then
		echo ElasticSearch Startup Success!
	else
		echo ElasticSearch Startup Failed!
	fi
}

neo4j() {
	neo4j_dir=$public/neo4j-community-3.4.17
	if [ ! -d "$neo4j_dir" ];then
		cd $soft
		tar xf neo4j-community-3.4.17-unix.tar.gz -C $public
		/app/public/neo4j-community-3.4.17/bin/neo4j start
	else
		echo neo4j already installed!
	fi

	if netstat -lntup| grep 7474;then
		echo Neo4j Startup Success!
	else
		echo Neo4j Startup Failed!
	fi
}

cafe() {
	if [ ! -d /app/public/caffe-ssd ];then
		cd $soft
		tar xf caffe-ssd.tar.gz -C $public
	else
		echo caffe-ssd already installed!
	fi
	echo Please run \"source /app/scripts/activate_caffe.sh\", load caffe environment!
}

card() {
	if  lspci | grep BM1684 ;then
		if [ ! -d /dev/bm-sophon0 ];then
			cd $soft
			tar xf bmnnsdk2-bm1684_v2.0.3.tar.gz -C /app/public/
			cd  bmnnsdk2-bm1684_v2.0.3/scripts/
			./install_lib.sh
			source  envsetup_pcie.sh ufw
			source envsetup_pcie.sh bmnetu
		else
			echo B_Card driver installed!
		fi
	else
		echo B_Card Device is not installed!
	fi
}
yujing_module() {
	aconda
	if [ ! -d  /app/biaozhu/action_prediction ];then
		cd $soft
		tar xf action_prediction.tar.gz -C /app/biaozhu/
		chown -R $username.$username /app
		cp /app/conf/python/predic.service /lib/systemd/system/
		sed -i "s%User=pdl%User=$username%g" /lib/systemd/system/predic.service
		sed -i "s%Group=pdl%Group=$username%g" /lib/systemd/system/predic.service
		systemctl daemon-reload
		systemctl enable predic.service
		systemctl start predic.service
	else
		echo yujing_module already installed!
	fi
	if systemctl status predic|grep Active|awk '{print $2}' >/dev/null 2>&1;then
		echo yujing_module Startup Success!
	else
		echo yujing_module Startup Failed!
	fi		
}
web() {
	mkdir -p /app/biaozhu/web
	if netstat -lntup| grep nginx| grep 8090 ;then
		cd $soft
		unzip -nq -d /app/biaozhu/web/ event-anno.zip
		IP=`ip a|grep enp|grep inet|awk -F '[ /]' '{print $6}'`
		sed -i s#10.107.17.70#$IP#g  /app/biaozhu/web/event-anno/resource/httpRequest.js
		sed -i s#10.107.17.70#$IP#g  /app/biaozhu/web/event-anno/views/event-wall/js/app.a9ed35ad.js
		chown -R $username.$username /app/biaozhu
		systemctl restart nginx
	else
		echo listen port  8090  is not open!
	fi
}

event() {
	cd $soft
	cp zlxsfs-0.0.1-SNAPSHOT.jar /app/biaozhu/
	tar xf annotation.tar.gz -C /app/biaozhu/
	cp /app/conf/event/event_start.sh /app/biaozhu/
	cp /app/conf/event/event.service /lib/systemd/system/
	sed -i "s%User=pdl%User=$username%g" /lib/systemd/system/event.service
	sed -i "s%Group=pdl%Group=$username%g" /lib/systemd/system/event.service
	systemctl daemon-reload
	systemctl enable event.service
	systemctl restart event.service
	echo event!
}

biaozhu() {
	echo ------------------------------------------------------------------------
	es
	echo ------------------------------------------------------------------------
	msql
	mysql -uroot -proot -h127.0.0.1 -e "create database shijianqiang;"
	mysql -uroot -proot shijianqiang < /app/conf/mysql/shijianqiang.sql
	echo ------------------------------------------------------------------------
	yujing_module
	echo ------------------------------------------------------------------------
	web
	echo ------------------------------------------------------------------------
	event
}

hadoop() {
	hadoop
}

case $1 in
anaconda)
	aconda
	echo activation python 3.6, please run \"source /app/scripts/activate_py36.sh\".
	echo activation python 3.7, please run \"source /app/scripts/activate_py37.sh\"	
	;;
nginx)
	ngx
	;;
jdk)
	jdk
	;;
mysql)
	msql
	;;
pytorch)
	torch
	;;
tensorflow)
	tenflow
	;;
elasticsearch)
	es
	;;
neo4j)
	neo4j
	;;
bcard)
	card
	;;
caffe)
	cafe
	;;
biaozhu)
	biaozhu
	;;
hadoop)
	hadoop
	;;
*)
	usage
	;;
esac

exit $?	
