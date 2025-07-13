resource "aws_secretsmanager_secret" "medusa" {
  name = "medusa_db_secret"
}

resource "aws_secretsmanager_secret_version" "medusa" {
  secret_id     = aws_secretsmanager_secret.medusa.id
  secret_string = jsonencode({
    username = "medusaadmin"
    password = var.db_password
  })
}
