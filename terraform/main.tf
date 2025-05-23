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

resource "aws_instance" "web" {
  ami                         = "ami-03a13a09a711d3871" # RHEL 10 Image
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true # Allowing accessibility from Github

  vpc_security_group_ids = [aws_security_group.sg_ssh.id]

  tags = {
    Name = "Terrafom-Ansible-RHEL10"
  }

}

resource "aws_key_pair" "my_key" {
  key_name   = "aws_keys_steph_${timestamp()}}" # Timestamp to ensure unique key name
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJj0uEfUBSUo2Xzq1E4EpMdiewB7dOQ9v9FcGd7YPmOs streadwell@ansible.2resolute.com"
}

resource "aws_security_group" "sg_ssh" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
}
