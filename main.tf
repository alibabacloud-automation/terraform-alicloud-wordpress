data "alicloud_images" "centos" {
  most_recent = true
  name_regex  = "centos_7"
}

locals {
  local_host             = var.create_rds_mysql == true ? module.mysql.this_db_instance_connection_string : ""
  wordpress_install      = var.create_rds_mysql == true ? "install-on-ecs-and-rds.sh" : "install-on-ecs.sh"
  wordpress_install_file = var.create_rds_mysql == true ? "${path.module}/install-on-ecs-and-rds.sh" : "${path.module}/install-on-ecs.sh"
  databse = [
    {
      name          = var.mysql_database_name
      character_set = var.mysql_database_character_set
      description   = "A MySql database used to deploy wordpress."
    }
  ]
}

# Create an ECS Instance to deploy wordpress
module "ecs-instance" {
  source                  = "alibaba/ecs-instance/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  number_of_instances = 1
  use_num_suffix      = false

  instance_name = var.ecs_instance_name
  password      = var.ecs_instance_password
  image_id      = var.image_id != "" ? var.image_id : data.alicloud_images.centos.ids.0
  instance_type = var.ecs_instance_type

  instance_charge_type = "PostPaid"
  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size

  security_group_ids = var.security_group_ids
  vswitch_ids        = [var.vswitch_id]
  private_ips        = [var.private_ip]

  internet_charge_type        = var.internet_charge_type
  associate_public_ip_address = true
  internet_max_bandwidth_out  = var.internet_max_bandwidth_out

  resource_group_id   = var.resource_group_id
  deletion_protection = var.deletion_protection
  force_delete        = true
  tags = merge(
    {
      Created     = "Terraform"
      Application = "Wordpress"
    }, var.tags,
  )

  data_disks  = var.data_disks
  volume_tags = var.volume_tags
}

// Create a rds mysql to store wordpress data
module "mysql" {
  source                  = "terraform-alicloud-modules/rds-mysql/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  ###############
  #Rds Instance#
  ###############
  create_instance      = var.create_rds_mysql
  engine_version       = var.mysql_engine_version
  vswitch_id           = var.vswitch_id
  instance_storage     = var.mysql_instance_storage
  instance_type        = var.mysql_instance_type
  instance_name        = var.mysql_instance_name
  instance_charge_type = "Postpaid"

  security_group_ids = var.security_group_ids

  tags = merge(
    {
      Created     = "Terraform"
      Application = "Wordpress"
    }, var.tags,
  )

  ###############
  #backup_policy#
  ###############
  create_backup_policy        = var.create_rds_mysql
  preferred_backup_period     = ["Monday", "Wednesday", "Friday"]
  preferred_backup_time       = "00:00Z-01:00Z"
  backup_retention_period     = 100
  log_backup_retention_period = 100
  enable_backup_log           = true

  ###########
  #databases#
  ###########
  create_account    = var.create_rds_mysql
  account_name      = var.mysql_account_name
  account_password  = var.mysql_account_password
  account_type      = var.mysql_account_type
  account_privilege = var.mysql_account_privilege

  create_database = var.create_rds_mysql
  databases       = local.databse

  enable_alarm_rule = false
}

# Upload deploy script
resource "null_resource" "file" {
  provisioner "file" {
    source      = local.wordpress_install_file
    destination = "/tmp/${local.wordpress_install}"
    connection {
      type     = "ssh"
      user     = "root"
      password = var.ecs_instance_password
      host     = module.ecs-instance.this_public_ip.0
    }
  }
}

# deploy wordpress
resource "null_resource" "remote" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.ecs_instance_password
      host     = module.ecs-instance.this_public_ip.0
    }
    inline = [
      "chmod +x /tmp/${local.wordpress_install}",
      "/tmp/${local.wordpress_install} ${var.mysql_database_name}  ${var.mysql_account_name}  ${var.mysql_account_password}  ${local.local_host} ",
    ]
  }
  depends_on = [null_resource.file]
}
