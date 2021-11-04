terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "builder" {
  ami = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"
  security_groups = ["sg-05252fc253494d7e5"]
  key_name = "ser2"
  subnet_id = "subnet-d9825094"
  associate_public_ip_address = true
  tags = {
    Name = "builder"
  }
}

resource "aws_instance" "web" {
  ami = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"
  security_groups = ["sg-05252fc253494d7e5"]
  key_name = "ser2"
  subnet_id = "subnet-d9825094"
  associate_public_ip_address = true
  tags = {
    Name = "web"
  }

  provisioner "local-exec" {
    command = "sleep 10; sed -i \"/builder/a ${aws_instance.builder.public_ip} ansible_ssh_user=ubuntu\" hosts; sed -i \"/web/a ${aws_instance.web.public_ip} ansible_ssh_user=ubuntu\" hosts"
  }
}