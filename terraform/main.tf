terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


resource "aws_security_group" "allow_ports" {
  name        = "allow_ports"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.aws_ssh_port
  ip_protocol       = "tcp"
  to_port           = var.aws_ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.aws_http_port
  ip_protocol       = "tcp"
  to_port           = var.aws_http_port
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.allow_ports.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "my_key" {
  key_name   = "deployer-key"
  public_key = file(var.public_key)
}

resource "aws_instance" "web" {
  ami                         = var.aws_ami # Amazon Linux 2
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ports.id]

  tags = {
    Name = "Terraform-Ansible-AmazonLinux"
  }
}


