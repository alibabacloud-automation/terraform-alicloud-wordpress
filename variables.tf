#################
# Provider
#################

variable "profile" {
  description = "The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}
variable "shared_credentials_file" {
  description = "This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}
variable "skip_region_validation" {
  description = "Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}
variable "region" {
  description = "The region used to launch this module resources."
  type        = string
  default     = ""
}

##################
# ECS instance
##################

variable "create_rds_mysql" {
  description = "Whether to create RDS MySql database. If false, this module will create MySql database on ECS."
  type        = bool
  default     = false
}
variable "ecs_instance_name" {
  description = "Name to be used on all resources as prefix. Default to 'TF-Module-ECS-Instance'."
  type        = string
  default     = "TF-Module-ECS-Instance"
}
variable "ecs_host_name" {
  description = "Host name used on all instances as prefix. Like TF-ECS-Host-Name-1, TF-ECS-Host-Name-2."
  type        = string
  default     = ""
}
variable "ecs_password" {
  description = "The password of instance."
  type        = string
  default     = ""
}
variable "image_id" {
  description = "The image id used to launch one ecs instances, Used to build wordpress (Support CentOS only)."
  type        = string
  default     = ""
}
variable "ecs_instance_type" {
  description = "The instance type used to launch one or more ecs instances."
  type        = string
  default     = ""
}
variable "system_disk_category" {
  description = "The system disk category used to launch one or more ecs instances."
  type        = string
  default     = ""
}
variable "security_groups" {
  description = "A list of security group ids to associate with."
  type        = list(string)
  default     = []
}
variable "vswitch_id" {
  description = "The virtual switch ID to launch in VPC."
  type        = string
  default     = ""
}
variable "internet_max_bandwidth_out" {
  description = "The maximum internet out bandwidth of instance."
  type        = number
  default     = 0
}
variable "data_disks" {
  description = "Additional data disks to attach to the scaled ECS instance"
  type        = list(map(string))
  default     = []
}
variable "security_ips" {
  description = "A list of security group ids to associate with."
  type        = list(string)
  default     = []
}

#################
# Mysql Instance
#################

variable "mysql_instance_storage_type" {
  description = "The storage type of the instance"
  type        = string
  default     = "local_ssd"
}

variable "mysql_engine_version" {
  description = "RDS Database version. Value options can refer to the latest docs [CreateDBInstance](https://www.alibabacloud.com/help/doc-detail/26228.htm) `EngineVersion`"
  type        = string
  default     = ""
}

variable "mysql_instance_name" {
  description = "The name of MySQL Instance. A random name prefixed with 'terraform-rds-' will be set if it is empty."
  type        = string
  default     = ""
}
variable "mysql_instance_charge_type" {
  description = "The instance charge type. Valid values: Prepaid and Postpaid. Default to Postpaid."
  type        = string
  default     = "Postpaid"
}
variable "mysql_period" {
  description = "The duration that you will buy MySQL Instance (in month). It is valid when instance_charge_type is PrePaid. Valid values: [1~9], 12, 24, 36. Default to 1"
  type        = number
  default     = 1
}
variable "mysql_instance_storage" {
  description = "The storage capacity of the instance. Unit: GB. The storage capacity increases at increments of 5 GB. For more information, see [Instance Types](https://www.alibabacloud.com/help/doc-detail/26312.htm)."
  type        = number
  default     = 20
}

variable "mysql_instance_type" {
  description = "MySQL Instance type, for example: mysql.n1.micro.1. full list is : https://www.alibabacloud.com/help/zh/doc-detail/26312.htm"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of VPC security group ids to associate with mysql instance."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the mysql."
  type        = map(string)
  default     = {}
}

#################
# MySQL Backup policy
#################

variable "preferred_backup_period" {
  description = "MySQL Instance backup period."
  type        = list(string)
  default     = []
}

variable "preferred_backup_time" {
  description = " MySQL Instance backup time, in the format of HH:mmZ- HH:mmZ. "
  type        = string
  default     = "02:00Z-03:00Z"
}

variable "backup_retention_period" {
  description = "Instance backup retention days. Valid values: [7-730]. Default to 7."
  type        = number
  default     = 7
}

variable "enable_backup_log" {
  description = "Whether to backup instance log. Default to true."
  type        = bool
  default     = false
}

variable "log_backup_retention_period" {
  description = "Instance log backup retention days. Valid values: [7-730]. Default to 7. It can be larger than 'retention_period'."
  type        = number
  default     = 7
}

#################
# MySQL Connection
#################

variable "allocate_public_connection" {
  description = "Whether to allocate public connection for a MySQL instance. If true, the connection_prefix can not be empty."
  type        = bool
  default     = true
}
variable "connection_prefix" {
  description = "Prefix of an Internet connection string. A random name prefixed with 'tf-rds-' will be set if it is empty."
  type        = string
  default     = ""
}

variable "mysql_connection_port" {
  description = " Internet connection port. Valid value: [3001-3999]. Default to 3306."
  type        = number
  default     = 3306
}

#################
# MySQL Database
#################

variable "databases" {
  description = "A list mapping used to add multiple databases. Each item supports keys: name, character_set and description. It should be set when create_database = true."
  type        = list(map(string))
  default     = []
}
variable "database_name" {
  description = "Name of a new database . It should be set when create_databases = true."
  type        = string
  default     = ""
}
variable "database_character_set" {
  description = "The value range is limited to the following."
  type        = string
  default     = "utf8"
}

#################
# MySQL Database account
#################

variable "database_account_name" {
  description = "Name of a new database account. It should be set when create_account = true."
  type        = string
  default     = ""
}
variable "database_account_password" {
  description = "Operation database account password. It may consist of letters, digits, or underlines, with a length of 6 to 32 characters."
  type        = string
  default     = ""
}
variable "database_account_type" {
  description = "Privilege type of account. Normal: Common privilege. Super: High privilege.Default to Normal."
  type        = string
  default     = "Normal"
}
variable "database_account_privilege" {
  description = "The privilege of one account access database."
  type        = string
  default     = "ReadOnly"
}

