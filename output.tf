output "this_instance_name" {
  value = alicloud_instance.this.*.instance_name
}
output "this_host_name" {
  value = alicloud_instance.this.*.host_name
}
output "password" {
  value       = alicloud_instance.this.*.password
}
output "availability_zone" {
  value       = alicloud_instance.this.*.availability_zone
}
output "this_image_id" {
  value = alicloud_instance.this.*.image_id
}
output "this_instance_type" {
  value = alicloud_instance.this.*.instance_type
}
output "this_system_disk_category" {
  value = alicloud_instance.this.*.system_disk_category
}
output "group_ids" {
  value       = alicloud_instance.this.*.security_groups
}
output "this_vswitch_id" {
  value = alicloud_instance.this.*.vswitch_id
}
output "this_user_data" {
  value = alicloud_instance.this.*.user_data
}
output "this_instance_id" {
  value = alicloud_instance.this.*.id
}

/*output "inner_connection_String" {
  value = module.rds.this_db_instance_connection_string
}*/

output "this_instance_allocate_public_ip" {
  value = alicloud_instance.this.*.allocate_public_ip
}

output "this_instance_public_ip" {
  value = alicloud_instance.this.*.public_ip
}

#################
# rds
#################
/*
output "rds_instance_id" {
  value = module.rds.this_db_instance_id
}
output "rds_instance_connection_ip_address" {
  value = module.rds.this_db_instance_connection_ip_address
}
output "rds_instance_connection_string" {
  value = module.rds.this_db_instance_connection_string
}
output "rds_instance_port" {
  value = module.rds.this_db_instance_port
}*/
