
# Create a target RDS instance

resource "aws_db_instance" "cyber-db" {
  identifier              = "${var.environment}-${var.identifier}"
  allocated_storage       = "${var.storage}"
  engine                  = "${var.engine}"
  engine_version          = "${var.engine_version}"
  instance_class          = "${var.instance_class}"
  name                    = "${var.db_name}"
  username                = "${var.username}"
  password                = "${var.password}"
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]
  multi_az                = "${var.rds_is_multi_az}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds-subnet.id}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"
  maintenance_window      = "${var.maintenance_window}"
  storage_encrypted       = "${var.storage_encrypted}"
  

tags {
    Name        = "rds"
    owner       = "${var.owner}"
    environment = "${var.environment}"
    created_by  = "terraform"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
  name        = "${var.environment}_rds_subnet_group"
  subnet_ids  = "${var.subnet_ids}"

  tags {
    Name        = "${var.environment}_rds_subnet_group"
    owner       = "${var.owner}"
    environment = "${var.environment}"
    created_by  = "terraform"
  }
}

resource "aws_security_group" "rds" {
   name        = "rds-sg"
   vpc_id = "${var.vpc_id}"

  ingress {
      from_port   ="${var.port}"
      to_port     = "${var.port}"
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
