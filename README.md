Terraform module which deploy a wordpress based on Alibaba Cloud ECS instance and RDS  Mysql database.  
terraform-alicloud-wordpress
-------

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/blob/master/README-CN.md)

Terraform Module used to install and deploy wordpress based on Alibab Cloud ECS and RDS.

This Module provides three deployment ways based on how to install MySql：

1. Set `create_rds_mysql = false`, and ECS Instance will install MySql and then to deploy Wordpress.
2. Set `create_rds_mysql = true`, and it will create a new Rds instance and MySql, and then to deploy Wordpress.

## Usage

#### Create a RDS mysql to deploy wordpress

```hcl
module "wordpress" {
  source = "terraform-alicloud-modules/wordrpress/alicloud"

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
From the version v1.1.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/wordpress"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.0.0:

```hcl
module "wordpress" {
  source               = "terraform-alicloud-modules/wordrpress/alicloud"
  version              = "1.0.0"
  region               = "cn-shanghai"
  profile              = "Your-Profile-Name"
  create_rds_mysql     = true
  mysql_engine_version = "5.7"
  // ...
}
```

If you want to upgrade the module to 1.1.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
  region  = "cn-shanghai"
  profile = "Your-Profile-Name"
}
module "wordpress" {
  source               = "terraform-alicloud-modules/wordrpress/alicloud"
  create_rds_mysql     = true
  mysql_engine_version = "5.7"
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-shanghai"
  profile = "Your-Profile-Name"
  alias   = "sh"
}
module "wordpress" {
  source               = "terraform-alicloud-modules/wordrpress/alicloud"
  providers            = {
    alicloud = alicloud.sh
  }
  create_rds_mysql     = true
  mysql_engine_version = "5.7"
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.56.0 |

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
