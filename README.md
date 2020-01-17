Terraform module which deploy a wordpress based on Alibaba Cloud ECS instance and RDS  Mysql database.

terraform-alicloud-wordpress
=====================================================================

Terraform module which creates wordpress based on ecs and rds on Alibaba Cloud. 

These types of resources are supported:

* [ECS Instance](https://www.terraform.io/docs/providers/alicloud/r/instance.html)

## Terraform versions

For Terraform 0.12 use version `v2.*` and `v1.3.0` of this module.

If you are using Terraform 0.11 you can use versions `v1.2.*`.

## Usage

```hcl
data "alicloud_images" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu_18.*64"
}

module "WebServer"  {
  source  = "alibaba/wordpress/alicloud"
  version = "~> 2.0"
  instance_name = "myDBInstance"
  host_name = "ecs-rds-wp"
  password = "123456qWe"
  availability_zone = "cn-beijing-f"
  image_id = data.alicloud_images.ubuntu.ids.0
  instance_type = "ecs.n4.small"
  system_disk_category = "cloud_efficiency"
  security_groups = ["sg-12345678"]
  vswitch_id = "vsw-fhuqiexxxxxxxxxxxx"
  internet_max_bandwidth_out  = 10
  system_disk_size     = 50
  user_data = "#!/bin/bash\n cd ~\n mkdir my_rds_test1\n sed -i 'WebRootPath='/var/www/html'\n' 'ApacheIndex='Options Indexes FollowSymLinks'\n' 'ApacheIndexReplace='Options Indexes FollowSymLinks'\n' 'mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup\n' 'wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo\n' 'yum makecache\n' 'yum install -y curl httpd mysql-server php56 php56-php-mysql\n' '#yum install -y curl httpd mysql-server php56 php-common php-mysql\n' 'yum install -y php56-php-gd php56-php-imap php56-php-ldap php56-php-odbc php56-php-xmlrpc\n' '#yum install -y php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc\n' 'chkconfig httpd on\n' 'wget http://wordpress.org/latest.tar.gz\n' 'tar -xzvf latest.tar.gz\n' 'sed -i \"s/database_name_here/${local.database_name_here}/\" wordpress/wp-config-sample.php\n' 'sed -i \"s/username_here/${local.username_here}/\" wordpress/wp-config-sample.php\n' 'sed -i \"s/password_here/${local.password_here}/\" wordpress/wp-config-sample.php\n' 'sed -i \"s/localhost/${local.localhost}/\" wordpress/wp-config-sample.php\n' 'mv wordpress/wp-config-sample.php wordpress/wp-config.php\n' 'cp -a wordpress/* $WebRootPath\n' 'rm -rf wordpress*\n' 'service httpd stop\n' 'usermod -d $WebRootPath apache &>/dev/null\n' 'chown apache:apache -R $WebRootPath\n'  'sed -i \"s/$ApacheIndex/$ApacheIndexReplace/\" /etc/httpd/conf/httpd.conf\n' 'service httpd start\n'"
}
```

## Examples

* [ecs&rds wordpress example](https://github.com/terraform-alicloud-modules/terraform-alicloud-ecs-instance/tree/master/examples/basic)

## Notes

* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.
* One of `vswitch_id` or `vswitch_ids` is required. If both are provided, the value of `vswitch_id` is prepended to the value of `vswitch_ids`.

Authors
-------
Created and maintained by  He Guimin(@xiaozhu36, heguimin36@163.com),Yi Jincheng (yi785301535@163.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)


