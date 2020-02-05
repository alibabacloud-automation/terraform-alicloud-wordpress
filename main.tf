
provider "alicloud" {
  version                 = ">=1.64.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : local.region
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/wordpress"
}
data "alicloud_images" "centos7" {
  most_recent = true
  name_regex  = "centos_7"
}

locals {
  create_rds_mysql   = var.create_rds_mysql
  region             = var.region != "" ? var.region : "cn-hangzhou"
  local_host         = local.create_rds_mysql == true ? module.mysql.this_db_instance_connection_string : ""
  wordpress_install  = var.create_rds_mysql == true ? "install-on-ecs-rds.sh" : "install-on-ecs.sh"
  create_db_instance = local.create_rds_mysql == true ? true : false
  databse = [
    {
      name          = var.database_name
      character_set = var.database_character_set
      description   = "db1"
    }
  ]
}

resource "alicloud_instance" "this" {
  instance_name              = var.ecs_instance_name
  host_name                  = var.ecs_host_name
  password                   = var.ecs_password
  image_id                   = var.image_id != "" ? var.image_id : data.alicloud_images.centos7.ids.0
  instance_type              = var.ecs_instance_type
  system_disk_category       = var.system_disk_category
  security_groups            = var.security_groups
  vswitch_id                 = var.vswitch_id
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
}

resource "null_resource" "this" {
  provisioner "file" {
    source      = local.wordpress_install
    destination = "/tmp/${local.wordpress_install}"
    connection {
      type     = "ssh"
      user     = "root"
      password = "YourPassword123"
      host     = alicloud_instance.this.public_ip
    }
  }
}

resource "null_resource" "this2" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "YourPassword123"
      host     = alicloud_instance.this.public_ip
    }
    inline = [
      "chmod +x /tmp/${local.wordpress_install}",
      "/tmp/${local.wordpress_install} ${var.database_name}  ${var.database_account_name}  ${var.database_account_password}  ${local.local_host} ",
    ]
  }
  depends_on = [null_resource.this]
}
module "mysql" {
  source = "terraform-alicloud-modules/rds-mysql/alicloud"
  region = var.region

  ###############
  #Rds Instance#
  ###############
  engine_version       = "5.7"
  connection_prefix    = "developmentabc"
  vswitch_id           = var.vswitch_id
  instance_storage     = 20
  instance_type        = "rds.mysql.s2.large"
  instance_name        = "myDBInstance"
  instance_charge_type = "Postpaid"
  security_ips = [
    "11.193.54.0/24",
    "121.43.18.0/24"
  ]

  tags = {
    Created     = "Terraform"
    Environment = "dev"
  }

  ###############
  #backup_policy#
  ###############

  preferred_backup_period     = ["Monday", "Wednesday"]
  preferred_backup_time       = "00:00Z-01:00Z"
  backup_retention_period     = 7
  log_backup_retention_period = 7
  enable_backup_log           = true

  ###########
  #databases#
  ###########
  account_name = var.database_account_name
  password     = var.database_account_password
  type         = "Normal"
  privilege    = "ReadWrite"
  databases    = local.databse

  #############
  # cms_alarm
  #############

  enabled         = false
  cms_name        = "CmsAlarmForMysql"
  statistics      = "Average"
  cms_period      = 300
  operator        = "<="
  threshold       = 35
  triggered_count = 2
  contact_groups  = ["MySQL"]
}