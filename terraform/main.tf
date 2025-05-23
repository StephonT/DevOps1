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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCSaB83jyDuIISieXwje4wGa1kzJzmi05phEwECX2ovcnxi3qNkqa+2QYhsXvrbNxzD0+96o7egpy6ecpwcYfPGdszeh23QlmAZMck8gK0fhUC1i6FR2SVJP9j6/MJaEg9xYvQ1OErsUKUbZHutTLNODnq/HjOshIVdgx7USHIve/HQl/rztMGosypNtQIH32GfkkmHQcu1WBLFcwCH63XRzS/0ieIUoH9ZCTxd8uJ+sbaYd22HWqe4vaUzYCjrIn7W4rZIC+hKaQimC+R8fRs0VF9OMuE824wC9pXd0peoo5Eij+2Jb+D2VsPIywy2DVl+D+u4Jserovqb+63ryYtrTGj4s4J0x3Xt2aPjlUSN9QGDCKJeK6VXrrWZuxMWy+MCaQByBATsmrwdJ2BceHtm3EbPHk/KxcYwg497lEByE2xtA2vqKHxLw4bEnh9PJ/At8Wf7jMA3LXIiAcCom1ml2Ats/EQpSUS/VLI/Iwoo+vnq07CfiqQy+Sd/AwF9A2E= streadwell@desiree10.niec.tc.faa.gov"
}

resource "aws_instance" "web" {
  ami                         = "ami-0953476d60561c955" # Amazon Linux 2
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Terraform-Ansible-AmazonLinux"
  }
}


