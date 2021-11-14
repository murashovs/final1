provider "aws" {
  region = "eu-north-1"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile = "default"
}
resource "aws_security_group" "allow_trafic" {
  name        = "security-group1"
  description = "Allow inbound traffic"


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "builder" {
  ami = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_trafic.id]
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
  vpc_security_group_ids = [aws_security_group.allow_trafic.id]
  key_name = "ser2"
  subnet_id = "subnet-d9825094"
  associate_public_ip_address = true
  tags = {
    Name = "web"
  }

  provisioner "local-exec" {
    command = "sed -i \"/builder/a ${aws_instance.builder.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/ser2.pem\" hosts; sed -i \"/web/a ${aws_instance.web.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/ser2.pem\" hosts"
  }
}