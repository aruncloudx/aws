variable "ssh_key_pair" {
  description = "SSH key pair to be provisioned on the instance"
  default = "test"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instance"
  default     = "false"
}

variable "instance_type" {
  description = "The type of the instance"
  default     = "m3.large"
}

variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  default = "vpc-12345"
}

variable "security_groups" {
  description = "List of Security Group IDs allowed to connect to the instance"
  default     = "sg-2fgeg649"
}

variable "subnet" {
  description = "VPC Subnet ID the instance is launched in"
  default = "subnet-0dgead55"
}


variable "region" {
  description = "AWS Region the instance is launched in"
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = "us-west-2c"
}

variable "instance_count" {
  description = "EC2 instance count"
  default     = "1"
}

variable "ami" {
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04"
  default     = "ami-80ke8ae5"
}

variable "ebs_optimized" {
  description = "Launched EC2 instance will be EBS-optimized"
  default     = "true"
}

variable "disable_api_termination" {
  description = "Enable EC2 Instance Termination Protection"
  default     = "false"
}


variable "root_volume_type" {
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  default     = "100"
}

variable "root_iops" {
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`"
  default     = "0"
}

variable "delete_on_termination" {
  description = "delete ebs volume on termination"
  default     = "true"
}

variable "instance_name" {
  description = "delete ebs volume on termination"
  default     = "terraform-automation"
}

variable "owner" {
  description = "delete ebs volume on termination"
  default     = "arun"
}

