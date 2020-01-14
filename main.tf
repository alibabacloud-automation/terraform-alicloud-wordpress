
variable "region" {
default = "cn-shanghai"
}
provider "alicloud" {
  region = var.region
}
data "alicloud_vpcs" "default" {
  is_default = true
}

module "sg" {
  source              = "alibaba/security-group/alicloud"
  region  = var.region
  vpc_id  =data.alicloud_vpcs.default.vpcs.0.id
  name = "test-lex-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}


data "alicloud_images" "centos6" {
  most_recent = true
  name_regex  = "centos_6"
}
resource "alicloud_instance" "this" {
  instance_name        = "myDBInstance3"
  host_name            = "ecs-rds-wp"
  password             = "123456qWe"
  image_id             = data.alicloud_images.centos6.ids.0
  instance_type        = "ecs.c5.large"//"ecs.n4.small"
  system_disk_category = "cloud_efficiency"
  security_groups      = [module.sg.this_security_group_id]
  vswitch_id           = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
  internet_max_bandwidth_out=10
  //depends_on = [module.rds]
//  provisioner "file" {
//    source      = "wp.sh"
//    destination = "/tmp/wp.sh"
//    connection {
//      type     = "ssh"
//      user     = self.instance_name
//      password = self.password
//      host     = self.public_ip
//    }
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "chmod +x /tmp/wp.sh",
//      "/tmp/wp.sh args",
//    ]
//  }
}

resource "null_resource" "this" {
  provisioner "file" {
    source = "wp.sh"
    destination = "/tmp/wp.sh"
    connection {
      type = "ssh"
      user = "root"
      password = "123456qWe"
      host = alicloud_instance.this.public_ip
    }
  }
}

//resource "null_resource" "this2" {
//
//  provisioner "remote-exec" {
//    connection {
//      type     = "ssh"
//      user     = "root"
//      password = "123456qWe"
//      host     = alicloud_instance.this.public_ip
//    }
//    inline = [
//      "chmod +x /tmp/wp.sh",
//      "/tmp/wp.sh args",
//    ]
//  }
//  depends_on = [null_resource.this]
//}



// todo rds
/*
module "rds" {
source               = "terraform-alicloud-modules/rds/alicloud"
engine               = "MySQL"
engine_version       = "5.6"
region               = var.region
connection_prefix    = "developmentabc5"
vswitch_id           = data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0
instance_storage     = 20
security_group_ids   = [module.security_group.this_security_group_id]
period               = 1
instance_type        = "rds.mysql.t1.small"
instance_name        = "myDBInstancemodule"
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
account_name = "dbaccount1"
password     = "123456qWe"
type         = "Normal"
privilege    = "ReadWrite"
databases = [
{
name          = "dbuserv1"
character_set = "utf8"
description   = "db1"
},
{
name          = "dbuserv2"
character_set = "utf8"
description   = "db2"
},
]
}*/


