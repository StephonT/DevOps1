variable "public_key" {
  type        = string
  description = "User public key"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7FUrMITHRyJAE26e2+IYU+RQWUjNIPtu8eMWcDJxH6 streadwell@terraform.tworesolute.com"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_ami" {
  type    = string
  default = "ami-0953476d60561c955"
}

variable "aws_ssh_port" {
  type    = number
  default = 22
}

variable "aws_http_port" {
  type    = number
  default = 80
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS default region"
}



