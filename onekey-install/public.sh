#!/bin/bash

# create 2021/08/23 by suhuihuang

# install nginx
cd /app/soft
tar xf nginx1.18_linux_arm.tar.gz -C /app/public
ln -sf /app/public/nginx1.18/sbin/nginx /usr/local/sbin/nginx
cp /app/conf/nginx/nginx.service /lib/systemd/system/nginx.service
systemctl daemon-reload 
systemctl enable nginx.service
systemctl restart nginx.service

# ubuntu sources.list configur
IP=`ip a| grep enp |grep inet| awk -F '[ /]' '{print $6}'`
srcIP=`grep 80 /app/conf/ubuntu/sources.list | awk -F '[:/]' '{print $4}'`
sed -i s#$scrIP#$IP#g /app/conf/ubuntu/sources.list

mv /etc/apt/sources.list /etc/apt/sources.list_bak
cp /app/conf/ubuntu/sources.list  /etc/apt/
cd /app/mirrors/
tar xf ubuntu-ports.tar.gz  -C  /app/public/nginx1.18/html/ubuntu18.04
apt update

# install jdk
cd /app/soft
tar xf jdk-8u271-linux-aarch64.tar.gz -C /app/public/
mv /app/public/jdk1.8.0_271/ /app/public/jdk1.8
sed -i.ori '$a export JAVA_HOME=/app/public/jdk1.8\nexport PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH\nexport CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar' /etc/profile
source /etc/profile
if java -version
then 
	echo JDK install Ok !
else 
	echo JDK install faild.
fi

# install mysql 
if mysql -V
then 
	echo mysql exits 
else
	apt update
	apt install mysql-server mysql-client
fi
systemctl enable mysql.service
systemctl restart mysql.service

# install anaconda
tar xf /app/soft/archiconda3.tar.gz -C /app/public/
sed -i  '1c #!/app/public/archiconda3/bin/python' /app/public/archiconda3/bin/conda
sed -i  '1c #!/app/public/archiconda3/bin/python' /app/public/archiconda3/bin/conda-env
sed -i  '1c _CONDA_EXE="/app/public/archiconda3/bin/conda"' /app/public/archiconda3/etc/profile.d/conda.sh
sed -i  '2c _CONDA_ROOT="/app/public/archiconda3"' /app/public/archiconda3/etc/profile.d/conda.sh
sed -i  '1c _CONDA_EXE="/app/public/archiconda3/bin/conda"' /app/public/archiconda3/etc/profile.d/conda.csh
sed -i  '2c _CONDA_ROOT="/app/public/archiconda3"' /app/public/archiconda3/etc/profile.d/conda.csh
sed -i  '1c set _CONDA_EXE "/app/public/archiconda3/bin/conda"' /app/public/archiconda3/etc/fish/conf.d/conda.fish
sed -i  '2c set _CONDA_ROOT "/app/public/archiconda3"' /app/public/archiconda3/etc/fish/conf.d/conda.fish
