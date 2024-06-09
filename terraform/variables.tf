variable "aws_region" {
  default = "us-west-2"
}

variable "ami_id" {
  default = "ami-0eb9d67c52f5c80e5"  # amazon linux 23
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "minecraft_server_key"
}

variable "public_key_path" {
  default = "../minecraft_server_key.pub"
}


variable "private_key_path" {
  default = "../minecraft_server_key"
}