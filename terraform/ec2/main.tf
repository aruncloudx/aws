resource "aws_instance" "default" {
  count                       = "${var.instance_count}"
  ami                         = "${var.ami}"
  availability_zone           = "${var.availability_zone}"
  instance_type               = "${var.instance_type}"
  ebs_optimized               = "${var.ebs_optimized}"
  disable_api_termination     = "${var.disable_api_termination}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.ssh_key_pair}"
  subnet_id                   = "${var.subnet}"

  root_block_device {
    volume_type           = "${var.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
  tags {
    "Name"  = "${var.instance_name}"
    "Owner" = "${var.owner}"
  }
}

data "aws_subnet" "selected" {
  id = "${var.subnet_ids[0]}"
}
