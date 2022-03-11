locals {
  instance_name_prefix       = terraform.workspace
  instance_type              = "t3.micro"
  jump_host_instance_type    = "t3.micro"
  masters_instance_type      = "t3.micro"
  minions_instance_type      = "t3.micro"
  instance_image             = "ami-04e905a52ec8010b2"
  instance_enable_ipv6       = false
  instance_enable_dynamic_ip = false
  ssh_public_key_name        = "${local.instance_name_prefix}_key"
  ssh_public_key_file        = var.ssh_public_key_file
  raw_ssh_user               = "admin"
  private_subnet_cidr        = "192.168.42.0/24"
  private_subnet_gw          = "192.168.42.1"
}

resource "aws_key_pair" "admin" {
   key_name   = "admin"
   public_key = file(local.ssh_public_key_file)
 }

resource "aws_security_group" "server" {
  name        = "server-sg"
    ingress {
        description      = "SSH Access"
        from_port        = "22"
        to_port          = "22"
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
        description      = "accept"
        from_port        = "0"
        to_port          = "0"
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
  tags = {
    Name = "server-sg"
  }
}

resource "aws_instance" "controller" {

  ami               = local.instance_image
  instance_type     = local.jump_host_instance_type
  vpc_security_group_ids  = ["${aws_security_group.server.id}"]
  key_name          = "admin"

  tags              = {
    Name    = "${local.instance_name_prefix}-controller"
  }

  root_block_device {
    volume_type = var.aws_volume_type
    volume_size = var.aws_volume_size
    delete_on_termination = var.aws_delete_on_termination
  }
  
}

resource "aws_instance" "masters" {

  for_each          = var.masters_configuration

  ami               = local.instance_image
  instance_type     = local.masters_instance_type
  availability_zone = each.value.aws_az
  vpc_security_group_ids  = ["${aws_security_group.server.id}"]
  key_name          = "admin"

  tags              = {
    Name    = each.value.name
  }

  root_block_device {
    volume_type = each.value.aws_volume_type
    volume_size = each.value.aws_volume_size
    delete_on_termination = each.value.aws_delete_on_termination
  }
  
}

resource "aws_instance" "minions" {

  count             = 3

  ami               = local.instance_image
  instance_type     = local.minions_instance_type
  availability_zone = var.aws_minions_az
  vpc_security_group_ids  = ["${aws_security_group.server.id}"]
  key_name          = "admin"

  tags              = {
    Name    = "${local.instance_name_prefix}-minion-0${count.index + 1}"
  }

  root_block_device {
    volume_type = var.aws_minions_volume_type
    volume_size = var.aws_minions_volume_size
    delete_on_termination = var.aws_minions_delete_on_termination
  }
  
}
