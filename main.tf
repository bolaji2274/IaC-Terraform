provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}