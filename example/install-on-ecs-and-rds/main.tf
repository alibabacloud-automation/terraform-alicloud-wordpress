variable "region" {
  default = "cn-beijing"
}
provider "alicloud" {
  region = var.region
}
data "alicloud_vpcs" "default" {
  is_default = true
}
data "alicloud_vswitches" "default" {
  ids = [data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0]
}
data "alicloud_db_instance_classes" "default" {
  zone_id        = data.alicloud_vswitches.default.vswitches.0.zone_id
  engine         = "MySQL"
  engine_version = "5.7"
}
module "wordpress" {
  source = "../../"
  region = var.region

  create_rds_mysql             = true
  mysql_engine_version         = "5.7"
  mysql_instance_type          = data.alicloud_db_instance_classes.default.instance_classes.0.instance_class
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
  security_group_ids         = [module.security_group.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 50
}
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "test-lex-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}
