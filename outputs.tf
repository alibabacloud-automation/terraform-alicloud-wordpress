#######
# ECS
#######

output "this_ecs_instance_name" {
  description = "The name of the ECS."
  value       = module.ecs-instance.this_instance_name[0]
}

output "this_ecs_availability_zone" {
  description = "The Zone to start the instance in."
  value       = module.ecs-instance.this_availability_zone[0]
}
output "this_ecs_image_id" {
  description = " The Image to use for the ecs instance."
  value       = module.ecs-instance.this_image_id[0]
}
output "this_ecs_instance_type" {
  description = "The type of instance to start."
  value       = module.ecs-instance.this_instance_type[0]
}
output "this_ecs_system_disk_category" {
  description = "The system disk category for ecs to use."
  value       = module.ecs-instance.this_system_disk_category[0]
}
output "this_ecs_security_group_ids" {
  description = "The security group ids in which the ecs instance."
  value       = module.ecs-instance.this_security_group_ids
}
output "this_ecs_vswitch_id" {
  description = "The vswitch id in which the ecs instance."
  value       = module.ecs-instance.this_vswitch_id[0]
}
output "this_ecs_instance_id" {
  description = "Ecs instance id"
  value       = module.ecs-instance.this_instance_id[0]
}
output "this_ecs_instance_public_ip" {
  description = "The ecs instance public ip."
  value       = module.ecs-instance.this_public_ip[0]
}
output "this_wordpress_url" {
  description = "The wordpress Access link."
  value       = format("http://%s/wp-admin/install.php", module.ecs-instance.this_public_ip[0])
}
#################
# rds
#################
output "this_db_instance_id" {
  description = "Rds instance id."
  value       = module.mysql.this_db_instance_id
}
output "this_db_instance_engine" {
  description = "Rds instance engine."
  value       = module.mysql.this_db_instance_engine
}
output "this_db_instance_engine_version" {
  description = "Rds instance engine version."
  value       = module.mysql.this_db_instance_engine_version
}
output "this_db_instance_type" {
  description = "Rds instance type."
  value       = module.mysql.this_db_instance_type
}
output "this_db_instance_storage" {
  description = "Rds instance storage."
  value       = module.mysql.this_db_instance_storage
}
output "this_db_instance_charge_type" {
  description = "Rds instance charge type."
  value       = module.mysql.this_db_instance_charge_type
}
output "this_db_instance_name" {
  description = "Rds instance name."
  value       = module.mysql.this_db_instance_name
}

output "this_db_instance_security_ips" {
  description = "Rds instance security ip list."
  value       = module.mysql.this_db_instance_security_ips
}
output "this_db_instance_zone_id" {
  description = "The zone id in which the Rds instance."
  value       = module.mysql.this_db_instance_zone_id
}
output "this_db_instance_vswitch_id" {
  description = "The vswitch id in which the Rds instance."
  value       = module.mysql.this_db_instance_vswitch_id
}
output "this_db_instance_security_group_ids" {
  description = "The security group ids in which the Rds instance."
  value       = module.mysql.this_db_instance_security_group_ids
}
output "this_db_instance_tags" {
  description = "Rds instance tags"
  value       = module.mysql.this_db_instance_tags
}
