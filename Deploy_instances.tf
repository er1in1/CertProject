variable "instances" {
  description = "List of EC2 instance types"
  type = list(string)
  default = ["t2.micro", "t2.micro"]
}

variable "my_access_key" {
  default = "your_access_key"
}

variable "my_secret_key" {
  default = "your_secret_key"
}

provider "aws" {
  region  = "us-east-2"
  access_key = var.my_access_key
  secret_key = var.my_secret_key
}

resource "aws_security_group" "d14" {
  name        = "d14-security-group"
  description = "Allow HTTP, HTTPS, SSH traffic and other traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Permit Any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform"
  }
}


resource "aws_instance" "d14" {
  count = 2
  key_name      = "DevOps school"
  ami           = "ami-0dd9f0e7df0f0a138"
  instance_type = "${element(var.instances, count.index)}"


  tags = {
    Name = "d14-${count.index + 1}"
  }

  vpc_security_group_ids = [aws_security_group.d14.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 29
  }
}
