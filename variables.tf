# Redis related variables
variable "apply_immediately" {
  type        = string
  default     = "false"
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = string
  default     = "true"
  description = "Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window"
}

variable "name" {
  description = "Name for the Redis replication group i.e. UserObject"
  type        = string
  default     = "redis-devops"
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of nodes in the redis cluster. *Ignored when `cluster_mode_enabled` == `true`*"
}

variable "automatic_failover_enabled" {
  type        = bool
  default     = true
  description = "Automatic failover (Not available for T1/T2 instances)"
}

variable "multi_az_enabled" {
  type        = bool
  default     = true
  description = "Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored)"
}

variable "redis_node_type" {
  description = "Instance type to use for creating the Redis cache clusters"
  type        = string
  default     = "cache.m5.large"
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "family" {
  type        = string
  default     = "redis6.x"
  description = "Redis family"
}

variable "redis_version" {
  type        = string
  description = "Redis version to use, defaults to 6.x"
  default     = "6.x"
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [{
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }]
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = true
  description = "Enable encryption at rest"
}

variable "transit_encryption_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis"
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = true
}

variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 0
}

variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 0
}

variable "redis_maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period"
  type        = string
  default     = "fri:08:00-fri:09:00"
}

variable "redis_snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period"
  type        = string
  default     = "06:30-07:30"
}

variable "redis_snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  type        = number
  default     = 0
}

# Redis Networking related variables
variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "ID"
  default     = []
}

variable "subnet_group_name" {
  type        = string
  description = "name of the subnet group"
  default     = "redis-devops"
}

variable "availability_zones" {
  description = "A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important"
  type        = list(any)
  default = [
    "us-east-1a",
  ]
}

variable "redis_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = string
  }))

  default = []
}

variable "mandatory_elasticache_tags" {
  type = map(any)
  default = {
    Owner          = "Infrastructure",
    Service        = "Elasticache Redis",
    Name           = "DevOps Redis",
    Classification = "Internal"
  }
  description = "The Default tags that should be present while creating the application"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

# Redis secret related variables
variable "redis_auth_token" {
  type        = string
  default     = ""
  description = "The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true. If specified must contain from 16 to 128 alphanumeric characters or symbols"
}

variable "redis_secret_name" {
  default = "redis-devops"
}

variable "redis_parameter_group_name" {
  description = "Name of the custom aws_elasticache_parameter_group"
  type        = string
}

# Redis snapshot related variables for future use
variable "snapshot_arns" {
  description = "A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
  type        = list(string)
  default     = []
}

variable "snapshot_name" {
  description = " The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource"
  type        = string
  default     = ""
}
