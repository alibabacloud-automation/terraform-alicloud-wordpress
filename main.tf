
provider "alicloud" {
  version                 = ">=1.64.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : local.region
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/wordpress"
}

data "alicloud_vpcs" "default" {
  is_default = true
}
locals {
  db_name          = "your_db_name"
  account_name     = "account1"
  account_password = "your_password"
  local_host       = module.mysql.this_db_instance_connection_string
  region           = var.region != "" ? var.region : "cn-hangzhou"
}

module "sg" {
  source              = "alibaba/security-group/alicloud"
  region              = local.region
  vpc_id              = data.alicloud_vpcs.default.ids.0
  name                = "test-lex-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

data "alicloud_images" "centos6" {
  most_recent = true
  name_regex  = "centos_7"
}
resource "alicloud_instance" "this" {
  instance_name              = "myDBInstance3"
  host_name                  = "ecs-rds-wp"
  password                   = "YourPassword123"
  image_id                   = data.alicloud_images.centos6.ids.0
  instance_type              = "ecs.n1.7xlarge" //"ecs.n4.small"
  system_disk_category       = "cloud_efficiency"
  security_groups            = [module.sg.this_security_group_id]
  vswitch_id                 = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out = 10
  data_disks {
    name        = "disk1"
    size        = "20"
    category    = "cloud"
    description = "disk1"
  }
}

resource "null_resource" "this" {
  provisioner "file" {
    source      = "wp.sh"
    destination = "/tmp/wp.sh"
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
      "chmod +x /tmp/wp.sh",
      "/tmp/wp.sh ${local.db_name}  ${local.account_name}  ${local.account_password}  ${local.local_host} ",
    ]
  }
  depends_on = [null_resource.this]
}
module "mysql" {
  source = "terraform-alicloud-modules/rds-mysql/alicloud"
  region = local.region

  ###############
  #Rds Instance#
  ###############

  engine_version       = "5.7"
  connection_prefix    = "developmentabc"
  vswitch_id           = "vsw-bp1tili2u5kxxxxxx"
  instance_storage     = 20
  instance_type        = "rds.mysql.s2.large"
  instance_name        = "myDBInstance"
  instance_charge_type = "Postpaid"
  security_ips = [
    "11.193.54.0/24",
    "121.43.18.0/24"
  ]

  tags = {
    Created      = "Terraform"
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

  account_name = local.account_name
  password     = local.account_password
  type         = "Normal"
  privilege    = "ReadWrite"
  databases = [
    {
      name          = local.db_name
      character_set = "utf8"
      description   = "db1"
    }
  ]

  #############
  # cms_alarm
  #############

 enabled =false
}