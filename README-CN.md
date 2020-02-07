terraform-alicloud-wordpress
=====================================================================

本 Terraform 模块将基于阿里云 ECS 实例和云数据库 MySql 来部署的 Wordpress。

本模版根据 MySql 数据库的安装方式提供了两种 Wordpress 的部署方式：

1. 设置参数 `create_rds_mysql = false`，直接在 ECS Instance 上安装 MySql 并完成 Worepress 的部署。
2. 设置参数 `create_rds_mysql = true`，创建一个新的 Rds MySql，然后在 ECS Instance 上完成 Worepress 的部署。

## Terraform 版本

本模板要求使用版本 Terraform 0.12 和 阿里云 Provider 1.56.0+。

## 用法

#### Create a RDS mysql to deploy wordpress

```hcl
module "wordpress" {
  source = "terraform-alicloud-modules/wordrpress/alicloud"
  region = var.region

  create_rds_mysql             = true
  mysql_engine_version         = "5.7"
  mysql_instance_type          = "rds.mysql.s2.large"
  mysql_database_name          = "wordpress"
  mysql_database_character_set = "utf8"
  mysql_account_name           = "wpuser"
  mysql_account_password       = "Wp123456"
  ###########
  # ECS
  ###########
  ecs_instance_name          = "myDBInstance3"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = "ecs.sn1ne.large"
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = ["sg-345678"]
  vswitch_id                 = "vsw-345678"
  internet_max_bandwidth_out = 50
}
```

#### Use mysql on ecs to deploy wordpress

```hcl
module "wordpress" {
  source = "terraform-alicloud-modules/wordrpress/alicloud"
  region = var.region

  create_rds_mysql             = false
  mysql_database_name          = "wordpress"
  mysql_database_character_set = "utf8"
  mysql_account_name           = "wpuser"
  mysql_account_password       = "YourDBPwd"
  ###########
  # ECS
  ###########
  ecs_instance_name          = "myDBInstance3"
  ecs_instance_password      = "YourPassword123"
  ecs_instance_type          = "ecs.sn1ne.large"
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = ["sg-45678"]
  vswitch_id                 = "vsw-345678"
  internet_max_bandwidth_out = 50
} 
```

## 示例

* [在 ECS 上部署 Wordpress 示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs)
* [在 ECS 和 RDS 上部署 Wordpress 示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs-and-rds)

## 注意事项

* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

作者
-------
Created and maintained by Yi Jincheng(yi785301535@163.com) and He Guimin(@xiaozhu36, heguimin36@163.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
