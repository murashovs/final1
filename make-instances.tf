provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "builder" {
  ami = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"
  key_name = "newkey1"
  security_groups = ["group1"]
  subnet_id = "subnet-d9825094"
  associate_public_ip_address = true
  tags = {
    Name = "builder"
  }
}

resource "aws_instance" "web" {
  ami = "ami-0bd9c26722573e69b"
  instance_type = "t3.micro"
  security_groups = ["group1"]
  key_name = "newkey1"
  subnet_id = "subnet-d9825094"
  associate_public_ip_address = true
  tags = {
    Name = "web"
  }

  provisioner "local-exec" {
    command = "sleep 140"
    command = "sed -i \"/builder/a ${aws_instance.builder.public_ip}\" hosts"
    command = "sed -i \"/web/a ${aws_instance.web.public_ip}\" hosts"
  }
}