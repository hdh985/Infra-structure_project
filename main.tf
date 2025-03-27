module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.201.0/24", "10.0.202.0/24"]
  availability_zones   = ["ap-northeast-2a", "ap-northeast-2c"]
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
}

module "ec2_asg" {
  source             = "./modules/ec2_asg"
  ami_id             = data.aws_ami.amazon_linux_2.id
  instance_type      = "t3.micro"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security_group.ec2_sg_id
  target_group_arn   = module.alb.target_group_arn
}

module "rds" {
  source              = "./modules/rds"
  db_username         = "admin"
  db_password         = "yourpassword123" # 실제 배포 환경에서는 tfvars 또는 secret 사용 권장
  private_subnet_ids  = module.vpc.private_subnet_ids
  rds_sg_id           = module.security_group.rds_sg_id
}
module "frontend" {
  source      = "./modules/frontend"
  bucket_name = "my-project-bucket-gyung-${random_id.suffix.hex}"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
