locals {
  redis_auth_token = length(var.redis_auth_token) > 0 ? var.redis_auth_token : random_string.redis_auth_token.result
  redis_host       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.redis.*.configuration_endpoint_address) : join("", aws_elasticache_replication_group.redis.*.primary_endpoint_address)
}

# Creating a random string to generate the password for the Redis host
resource "random_string" "redis_auth_token" {
  length  = 16
  special = false
}

# Creating a subnet group for Redis
resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.name}-redis-subnet-group"
  description = "This is Subnet where redis will live"
  subnet_ids  = var.subnet_ids
}

# Creating the elasticache parameter group with custom parameters
resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name   = length(var.redis_parameter_group_name) > 0 ? var.redis_parameter_group_name : "${var.name}-cache-params"
  family = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_replication_group" "redis" {

  replication_group_id          = var.name
  replication_group_description = "Terraform-managed ElastiCache replication group for ${var.name}"
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  node_type                     = var.redis_node_type
  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  availability_zones            = var.cluster_mode_enabled ? null : var.availability_zones
  engine                        = "redis"
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = local.redis_auth_token
  engine_version                = var.redis_version
  port                          = var.redis_port
  parameter_group_name          = join("", aws_elasticache_parameter_group.redis_parameter_group.*.name)
  subnet_group_name             = aws_elasticache_subnet_group.redis.id
  security_group_ids            = [aws_security_group.redis.id]
  apply_immediately             = var.apply_immediately
  maintenance_window            = var.redis_maintenance_window
  snapshot_window               = var.redis_snapshot_window
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  tags                          = merge(var.mandatory_elasticache_tags, var.tags)


  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }

}

resource "aws_security_group" "redis" {
  vpc_id      = var.vpc_id
  description = "Terraform-managed ElastiCache security group for ${var.name}"
  name        = "${var.name}-redis-sg"
  tags        = var.tags
}

resource "aws_security_group_rule" "redis" {
  count = length(var.redis_ingress_rules)

  type              = "ingress"
  from_port         = var.redis_ingress_rules[count.index].from_port
  to_port           = var.redis_ingress_rules[count.index].to_port
  protocol          = var.redis_ingress_rules[count.index].protocol
  cidr_blocks       = [var.redis_ingress_rules[count.index].cidr_blocks]
  description       = var.redis_ingress_rules[count.index].description
  security_group_id = aws_security_group.redis.id
}
