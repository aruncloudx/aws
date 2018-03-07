resource "aws_security_group" "default" {
  name        = "dms"
  vpc_id = "${var.vpc_id}"

  ingress {
      from_port   ="${var.from_port}"
      to_port     = "${var.to_port}"
      protocol    = "tcp"
      cidr_blocks = ["172.31.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_dms_replication_instance" "dms-dev" {
  allocated_storage            = "${var.replication_instance_storage}"
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = "${lookup(var.availability_zones, count.index)}"
  engine_version               = "${var.replication_instance_version}"
  multi_az                     = false
  preferred_maintenance_window = "${var.replication_instance_maintenance_window}"
  publicly_accessible          = false
  replication_instance_class   = "${var.replication_instance_class}"
  replication_instance_id      = "${var.environment}-dms-replication-instance"
  replication_subnet_group_id  = "${aws_dms_replication_subnet_group.dms.id}"
  vpc_security_group_ids       = ["${aws_security_group.default.id}"]

  tags {
    owner       = "${var.owner}"
    environment = "${var.environment}"
  }
}

# Create a subnet group
resource "aws_dms_replication_subnet_group" "dms" {
  replication_subnet_group_description = "DMS replication subnet group"
  replication_subnet_group_id          = "dms-replication-subnet-group"
  subnet_ids                          =  "${var.subnet_ids}"
}

# Create S3 buckets
resource "aws_s3_bucket" "buckets" {
  count    = "${length(var.bucket_base_names)}"
  bucket   = "${element(var.bucket_base_names, count.index)}"
}

# S3 buckets with ecryption
resource "aws_s3_bucket_policy" "bucket" {
  count    = "${length(var.bucket_base_names)}"
  bucket =  "${element(aws_s3_bucket.buckets.*.id, count.index)}"
  policy =<<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy1508188638158",
    "Statement": [
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${format("%s:::%s%s", "arn:aws:s3", element(var.bucket_base_names, count.index), format("/*"))}",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "AES256"
                }
            }
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
           "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "${format("%s:::%s%s", "arn:aws:s3", element(var.bucket_base_names, count.index), format("/*"))}",
	    "Condition": {
               "Null": {
                    "s3:x-amz-server-side-encryption": "true"
                }
            }
        }
    ]
}

POLICY
}
