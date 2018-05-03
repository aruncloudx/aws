
# This file is used to set variables 


provider "aws" {
  region = "us-west-2"
}

variable "availability_zones" {
  description = "Geographically distanced areas inside the region"

  default = {
    "0" = "us-west-2a"
    "1" = "us-west-2b"
    "2" = "us-west-2c"
  }
}

#--------------------------------------------------------------
# Meta Data
#--------------------------------------------------------------

# Tagging


variable "owner" {
  description = "Owner of the DB"
  default     = "arun"
}

variable "environment" {
  description = "Name of the env"
  default     = "dev"
}

#--------------------------------------------------------------
# DMS general config
#--------------------------------------------------------------

variable "identifier" {
  default     = "rds"
  description = "Name of the database in the RDS"
}

#--------------------------------------------------------------
# DMS config
#--------------------------------------------------------------

variable "backup_retention_period" {
  # Days
  default     = "30"
  description = "Retention of RDS backups"
}

variable "backup_window" {
  # 12:00AM-03:00AM AEST
  default     = "14:00-17:00"
  description = "RDS backup window"
}

variable "db_name" {
  description = "Name of the database"
}

variable "db_port" {
  description = "The port the Application or client will access the database on"
  default     = 3306
}

variable "engine" {
  default     = "mysql"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"
  default     = "5.7.16"
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "maintenance_window" {
  default     = "Mon:00:00-Mon:03:00"
  description = "RDS maintenance window"
}

variable "password" {
  description = "Password of the database"
}

variable "rds_is_multi_az" {
  description = "Create backup database in separate availability zone"
  default     = "false"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "storage_encrypted" {
  description = "Encrypt storage or leave unencrypted"
  default     = false
}

variable "username" {
  description = "Username to access the database"
}

variable "subnet_cidr" {
  default     = ["172.31.16.0/20", "172.31.32.0/20", "172.31.0.0/20"]
  description = "List of subnets"
}

variable "subnet_ids" {
  type        = "list"
  default     = ["subnet-f862968f", "subnet-d31accb6", "subnet-6f8c9829"]
  description = "List of subnets ids"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.31.0.0/16"
}
variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-c48a4fa1"
}

variable "port" {
  default = "3306"
}
