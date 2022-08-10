
output "parameter_group" {
  value = aws_elasticache_parameter_group.redis_parameter_group.id
}

output "id" {
  value = aws_elasticache_replication_group.redis.id
}

output "port" {
  value = var.redis_port
}

output "endpoint" {
  value       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.redis.*.configuration_endpoint_address) : join("", aws_elasticache_replication_group.redis.*.primary_endpoint_address)
  description = "Redis primary endpoint"
}
