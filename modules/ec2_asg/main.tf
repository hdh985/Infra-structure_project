resource "aws_launch_template" "this" {
  name_prefix   = "dev-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              echo "Hello from ASG EC2!" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF
  )

  tags = {
    Name = "dev-launch-template"
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "dev-asg"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  vpc_zone_identifier       = var.private_subnet_ids

  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 30

  tag {
    key                 = "Name"
    value               = "dev-asg-ec2"
    propagate_at_launch = true
  }
}
