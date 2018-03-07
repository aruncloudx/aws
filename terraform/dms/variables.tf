variable "availability_zones" {
  description = "Geographically distanced areas inside the region"

  default = {
    "0" = "us-west-2a"
    "1" = "us-west-2b"
    "2" = "us-west-2c"
  }
}

# Tagging


variable "owner" {
  description = "Owner of the DMS resources"
  default     = "arun"
}

variable "environment" {
  description = "Used for seperating envs"
  default     = "dev"
}



#--------------------------------------------------------------
# DMS Replication Instance
#--------------------------------------------------------------

variable "replication_instance_maintenance_window" {
  description = "Maintenance window for the replication instance"
  default     = "sun:10:30-sun:14:30"
}

variable "replication_instance_storage" {
  description = "Size of the replication instance in GB"
  default     = "20"
}

variable "replication_instance_version" {
  description = "Engine version of the replication instance"
  default     = "2.4.1"
}

variable "replication_instance_class" {
  description = "Instance class of replication instance"
  default     = "dms.t2.micro"
}

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

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

 variable "bucket_base_names" {
  description = "S3 buckets"
  default = ["cybercloudx-dev", "cybercloudx-prod"]
 }

variable "from_port" {
  description = "From port number"
  default     = "0"
}

variable "to_port" {
  description = "To port number"
  default     = "65535"
}

