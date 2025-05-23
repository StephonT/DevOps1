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
  ami           = "ami-03a13a09a711d3871" # RHEL 10 Image
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name


  tags = {
    Name = "Terrafom-Ansible-RHEL10"
  }

}

resource "aws_key_pair" "my_key" {
  key_name   = "aws_keys_steph_${timestamp()}}" # Timestamp to ensure unique key name
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJj0uEfUBSUo2Xzq1E4EpMdiewB7dOQ9v9FcGd7YPmOs streadwell@ansible.2resolute.com"
}
