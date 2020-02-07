variable "region" {
  default = "cn-beijing"
}
provider "alicloud" {
  region = var.region
}

############################################
# Data sources to get VPC, vswitch details
############################################

data "alicloud_vpcs" "default" {
  is_default = true
}
module "wordpress" {
  source = "../../"
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
  security_group_ids         = [module.security_group.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 50
}

##################################################################
# Create a new security group using terraform module
##################################################################
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "test-lex-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}