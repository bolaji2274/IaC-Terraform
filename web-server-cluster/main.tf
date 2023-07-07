resource "aws_launch_configuration" "web" {
  image_id = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello WebServer" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF 
  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web.name
  min_size = 2
  max_size = 5

  tag {
    key = "Name"
    value = "terraform-asg-web"
    propagate_at_launch = true
  }
}