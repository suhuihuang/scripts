#!/bin/bash

usage() {
	echo "Usage: install  [anaconda|nginx|jdk|mysql|pytorch|tensorflow|elasticsearch|neo4j]"
}


# type java    判断软件是否安装


username() {
	echo create username kylin ....
	adduser kylin;
	echo kylin:123456 |chpasswd;
	echo kylin user  create success!
	chown -R kylin.kylin /app
}

anaconda() {
	echo anaconda -_- !
}
	
nginx() {
	echo nginx -_- !
}

jdk() {
	echo JDK -_- !
}

mysql() {
	echo MySQL -_- !
}

pytorch() {
	echo PyTorch -_- !
}

tensorflow() {
	echo TensorFlow -_- !
}

elasticsearch() {
	echo ElasticSearch -_- !
}

neo4j() {
	echo neo4j -_- !
}


# 判断 kyin 是否存在
if id kylin >/dev/null 2>&1;then
	#echo kylin exits!
	chown -R kylin.kylin /app
else
	username
	exit 0;
fi

# 判断当前为 kylin 用户
if [[ $(whoami) == kylin ]];then
	echo kylin user！
else
	echo Currently the `whoami` user, Switching kylin user!
	su - kylin
	exit 0
fi





case $1 in
anaconda)
	anaconda
	;;
nginx)
	nginx
	;;
jdk)
	jdk
	;;
mysql)
	mysql
	;;
pytorch)
	pytorch
	;;
tensorflow)
	tensorflow
	;;
elasticsearch)
	elasticsearch
	;;
neo4j)	
	neo4j
	;;
*)
	usage
	;;
esac

exit $?	
