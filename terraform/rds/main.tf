resource "aws_db_instance" "medusa_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "14.3"
  instance_class       = "db.t3.micro"
  name                 = "medusadb"
  username             = "medusaadmin"
  password             = var.db_password
  skip_final_snapshot  = true
  publicly_accessible  = true
}

output "db_endpoint" {
  value = aws_db_instance.medusa_db.endpoint
}

variable "db_password" {
  type = string
}
