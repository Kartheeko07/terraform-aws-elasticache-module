resource "aws_secretsmanager_secret" "secret" {
  description = "Secret to store the Elasticache authentication details"
  name        = var.redis_secret_name
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = <<EOF
{
  "redis.auth": "${local.redis_auth_token}",
  "redis.host": "${local.redis_host}",
  "redis.port": "${var.redis_port}"
}
EOF
}
