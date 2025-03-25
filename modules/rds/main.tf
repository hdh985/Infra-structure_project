resource "aws_db_subnet_group" "this" {
  name       = "dev-db-subnet"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "dev-db-subnet"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "dev-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "dev-rds"
  }
}
