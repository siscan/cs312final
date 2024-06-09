provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "minecraft_server" {
  ami           = "ami-0eb9d67c52f5c80e5"  # Amazon Linux 2023 AMI 2023.4.20240528.0 x86_64 HVM kernel-6.1
  instance_type = var.instance_type
  key_name      = aws_key_pair.minecraft_server_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "Minecraft Server"
  }
}

resource "aws_key_pair" "minecraft_server_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "minecraft_sg" {
  name_prefix = "minecraft-"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

output "public_ip" {
  value = aws_instance.minecraft_server.public_ip
}