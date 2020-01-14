#!/bin/sh
  WebRootPath='/var/www/html'
  ApacheIndex='Options Indexes FollowSymLinks'
  ApacheIndexReplace='Options Indexes FollowSymLinks'
  mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
  yum makecache
  yum install -y unzip zip
  yum install -y httpd


#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
#wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
#rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm
#yum install php70-php php70-php-pear php70-php-bcmath php70-php-pecl-jsond-devel php70-php-mysqlnd php70-php-gd php70-php-common php70-php-fpm php70-php-intl php70-php-cli php70-php php70-php-xml php70-php-opcache php70-php-pecl-apcu php70-php-pecl-jsond php70-php-pdo php70-php-gmp php70-php-process php70-php-pecl-imagick php70-php-devel php70-php-mbstring php70-php-mcrypt

  #yum install -y epel-release
  #rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
 # yum install -y --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof
 # rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
 # yum install -y mariadb mariadb-server
  #yum install --enablerepo=remi --enablerepo=remi-php56 php php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit -y

rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum install -y --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof

  yum install -y curl httpd mysql-server php56 php56-php-mysql
  rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
  rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
  yum install -y php56w.x86_64 php56w-cli.x86_64 php56w-common.x86_64 php56w-gd.x86_64 php56w-imap.x86_64 php56w-ldap.x86_64 php56w-mysql.x86_64 php56w-pdo.x86_64 php56w-odbc.x86_64 php56w-process.x86_64 php56w-xml.x86_64 php56w-xmlrpc.x86_64

 # yum clean all
  #rpm --rebuilddb
  #yum -y update
  # wget http://wordpress.org/latest.tar.gz
  # tar -xzvf latest.tar.gz
  chkconfig httpd on
  wget https://ros-userdata-resources.oss-cn-beijing.aliyuncs.com/WordPress/WordPress.zip
  unzip WordPress.zip
  mv WordPress-master wordpress
  cp wordpress/wp-config-sample.php wordpress/backup-wp-config.php
  sed -i "s/database_name_here/dbuserv2/" wordpress/wp-config-sample.php
  sed -i "s/username_here/dbaccount1/" wordpress/wp-config-sample.php
  sed -i "s/password_here/123456qWe/" wordpress/wp-config-sample.php
  sed -i "s/localhost/rm-uf66r94t9sfn4n85l.mysql.rds.aliyuncs.com/ " wordpress/wp-config-sample.php
  mv wordpress/wp-config-sample.php wordpress/wp-config.php
  cp -a wordpress/* $WebRootPath
  rm -rf wordpress*
  service httpd stop
  usermod -d $WebRootPath apache &>/dev/null
  chown apache:apache -R $WebRootPath
  sed -i "s/$ApacheIndex/$ApacheIndexReplace/" /etc/httpd/conf/httpd.conf
  service httpd start

