variable "region" {
  default = "cn-beijing"
}
provider "alicloud" {
  region = var.region
}

data "alicloud_vpcs" "default" {
  is_default = true
}
module "wp" {
  source                    = "../../"
  create_rds_mysql          = false
  region                    = var.region
  database_name             = "your_db_name"
  database_account_name     = "account1"
  database_account_password = "your_password"
  database_character_set    = "utf8"
  ###########
  # ECS
  ###########
  ecs_instance_name          = "myDBInstance3"
  ecs_host_name              = "ecs-rds-wp"
  ecs_password               = "YourPassword123"
  ecs_instance_type          = "ecs.n1.7xlarge"
  system_disk_category       = "cloud_efficiency"
  security_groups            = [module.sg.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 10
}
module "sg" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "test-lex-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}