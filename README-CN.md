terraform-alicloud-wordpress
=====================================================================

本 Terraform 模块将基于阿里云 ECS 实例和云数据库 MySql 来部署的 Wordpress。

本模版根据 MySql 数据库的安装方式提供了两种 Wordpress 的部署方式：

1. 设置参数 `create_rds_mysql = false`，直接在 ECS Instance 上安装 MySql 并完成 Worepress 的部署。
2. 设置参数 `create_rds_mysql = true`，创建一个新的 Rds MySql，然后在 ECS Instance 上完成 Worepress 的部署。

## 用法

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

## 示例

* [在 ECS 上部署 Wordpress 示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs)
* [在 ECS 和 RDS 上部署 Wordpress 示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs-and-rds)

## 注意事项
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显示设置：

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/wordpress"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

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

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显示定义一个系统过Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显示指定这个provider：

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

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.56.0 |

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
