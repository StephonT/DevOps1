terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.12.1"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_${timestamp()}"
  description = "Allow SSH from anywhere"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "aws_keys_${timestamp()}"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJj0uEfUBSUo2Xzq1E4EpMdiewB7dOQ9v9FcGd7YPmOs streadwell@ansible.2resolute.com"
}

resource "aws_instance" "web" {
  ami                         = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Terraform-Ansible-AmazonLinux"
  }
}


