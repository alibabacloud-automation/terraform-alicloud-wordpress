#!/bin/sh

WebRootPath='/var/www/html/'
ApacheIndex='Options Indexes FollowSymLinks'
ApacheIndexReplace='Options Indexes FollowSymLinks'
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum makecache
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql-community-server
systemctl start mysqld.service
yum install -y unzip zip
yum install -y httpd
yum install -y curl httpd mysql-server php56 php56-php-mysql
rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install -y php56w.x86_64 php56w-cli.x86_64 php56w-common.x86_64 php56w-gd.x86_64 php56w-imap.x86_64 php56w-ldap.x86_64 php56w-mysql.x86_64 php56w-pdo.x86_64 php56w-odbc.x86_64 php56w-process.x86_64 php56w-xml.x86_64 php56w-xmlrpc.x86_64
chkconfig httpd on
wget https://ros-userdata-resources.oss-cn-beijing.aliyuncs.com/WordPress/WordPress.zip
unzip WordPress.zip
mv WordPress-master wordpress
cp wordpress/wp-config-sample.php wordpress/backup-wp-config.php
sed -i "s/database_name_here/$1/" wordpress/wp-config-sample.php
sed -i "s/username_here/$2/" wordpress/wp-config-sample.php
sed -i "s/password_here/$3/" wordpress/wp-config-sample.php
mv wordpress/wp-config-sample.php wordpress/wp-config.php
cp -a wordpress/* $WebRootPath
rm -rf wordpress*
service httpd stop
usermod -d $WebRootPath apache &>/dev/null
chown apache:apache -R $WebRootPath
sed -i "s/$ApacheIndex/$ApacheIndexReplace/" /etc/httpd/conf/httpd.conf
service httpd start
service mysqld start