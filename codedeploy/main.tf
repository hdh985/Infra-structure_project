resource "aws_iam_role" "codedeploy" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "backend" {
  name = "my-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "backend" {
  app_name              = aws_codedeploy_app.backend.name
  deployment_group_name = "my-deploy-group"
  service_role_arn      = aws_iam_role.codedeploy.arn

  deployment_style {
    deployment_type = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  auto_scaling_groups = [var.asg_name]

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "dev-asg-ec2"
  }

  load_balancer_info {
    target_group_info {
      name = var.target_group_name
    }
  }
}
