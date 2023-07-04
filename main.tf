provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.web_sg.id ]

user_data = <<-EOF
            #!/bin/bash
            echo "Hello Bolaji Hammed" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF
user_data_replace_on_change = true

  tags = {
    Name = "terraform-web"
  }
}
resource "aws_security_group" "web_sg" {
  name = "terraform-web-sg"
  
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

output "public_ip" {
  value = aws_instance.web.public_ip
  description = "This is the public ip address of a web-server"
}