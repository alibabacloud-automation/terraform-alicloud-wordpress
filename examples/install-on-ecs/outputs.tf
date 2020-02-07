#######
# ECS
#######

output "this_ecs_instance_name" {
  description = "The name of the ECS."
  value       = module.wordpress.this_ecs_instance_name
}

output "this_ecs_availability_zone" {
  description = "The Zone to start the instance in."
  value       = module.wordpress.this_ecs_availability_zone
}
output "this_ecs_image_id" {
  description = " The Image to use for the ecs instance."
  value       = module.wordpress.this_ecs_image_id
}
output "this_ecs_instance_type" {
  description = "The type of instance to start."
  value       = module.wordpress.this_ecs_instance_type
}
output "this_ecs_system_disk_category" {
  description = "The system disk category for ecs to use."
  value       = module.wordpress.this_ecs_system_disk_category
}
output "this_ecs_security_group_ids" {
  description = "The security group ids in which the ecs instance."
  value       = module.wordpress.this_ecs_security_group_ids
}
output "this_ecs_vswitch_id" {
  description = "The vswitch id in which the ecs instance."
  value       = module.wordpress.this_ecs_vswitch_id
}
output "this_ecs_instance_id" {
  description = "Ecs instance id"
  value       = module.wordpress.this_ecs_instance_id
}
output "this_ecs_instance_public_ip" {
  description = "The ecs instance public ip."
  value       = module.wordpress.this_ecs_instance_public_ip
}
output "this_wordpress_url" {
  description = "The wordpress Access link."
  value       = module.wordpress.this_wordpress_url
}

