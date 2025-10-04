variable "public_key" {
  type        = string
  description = "User public key"
  default     = "~/.ssh/id_ed25519.pub"
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



