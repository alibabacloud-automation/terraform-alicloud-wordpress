Terraform模块，部署基于阿里云ECS实例和云数据库Mysql的wordpress

terraform-alicloud-wordpress
=====================================================================

## 用法

```hcl
module "wp" {
  source            = "terraform-alicloud-modules/wordrpress/alicloud"
  create_rds_mysql = true
  region            = "cn-hangzhou"
  db_name           = "your_db_name"
  account_name      = "account1"
  account_password  = "your_password"
  ###########
  # ECS
  ###########
  ecs_instance_name          = "myDBInstance3"
  ecs_host_name              = "ecs-rds-wp"
  ecs_password               = "YourPassword123"
  ecs_instance_type          = "ecs.n1.7xlarge"
  system_disk_category       = "cloud_efficiency"
  security_groups            = ["1.1.1.1"]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 10
}
```


## 示例

* [install-on-ecs example](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs)
* [install-on-ecs-rds example](https://github.com/terraform-alicloud-modules/terraform-alicloud-wordpress/tree/master/examples/install-on-ecs-rds)

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
