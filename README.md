Terraform module which deploy a wordpress based on Alibaba Cloud ECS instance and RDS  Mysql database.  
terraform-alicloud-wordpress
-------

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/blob/master/README-CN.md)

Terraform Module used to install and deploy wordpress based on Alibab Cloud ECS and RDS.

This Module provides three deployment ways based on how to install MySql：

1. Set `create_rds_mysql = false`, and ECS Instance will install MySql and then to deploy Wordpress.
2. Set `create_rds_mysql = true`, and it will create a new Rds instance and MySql, and then to deploy Wordpress.

## Terraform versions

This module requires Terraform 0.12 and Terraform Provider AliCloud 1.56.0+.

## Usage

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

## Examples

* [install-on-ecs example](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs)
* [install-on-ecs-and-rds example](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs-and-rds)

## Notes

* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
