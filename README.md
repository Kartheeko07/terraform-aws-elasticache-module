# terraform-aws-elasticache-module
This terraform module is to create an AWS ElastiCache Replica Set/Cluster.

## Table of contents

- [terraform-aws-elasticache-module](#terraform-aws-elasticache-module)
  - [Table of contents](#table-of-contents)
  - [Overview](#overview)
  - [Usage](#usage)
  - [Docs](#docs)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  
## Overview
  -  A Terraform module to create an AWS Redis ElastiCache Replica Set

## Usage 
```hcl
module "aws-elasticache" {
  source = "git@github.com:Kartheeko07/terraform-aws-elasticache-module.git?ref=LATEST_VERSION"

  ...

  tags = var.tags
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0, < 0.15.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `string` | `"false"` | no |
| at\_rest\_encryption\_enabled | Enable encryption at rest | `bool` | `true` | no |
| auto\_minor\_version\_upgrade | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window | `string` | `"true"` | no |
| automatic\_failover\_enabled | Automatic failover (Not available for T1/T2 instances) | `bool` | `true` | no |
| availability\_zones | A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important | `list(any)` | <pre>[<br>  "us-east-1a"<br>]</pre> | no |
| cluster\_mode\_enabled | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `true` | no |
| cluster\_mode\_num\_node\_groups | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| cluster\_mode\_replicas\_per\_node\_group | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| cluster\_size | Number of nodes in the redis cluster. \*Ignored when `cluster_mode_enabled` == `true`\* | `number` | `2` | no |
| family | Redis family | `string` | `"redis5.0"` | no |
| mandatory\_elasticache\_tags | The Default tags that should be present while creating the application | `map(any)` | <pre>{<br>  "Classification": "Internal",<br>  "Name": "BizOps Redis",<br>  "Owner": "Infrastructure",<br>  "Service": "Elasticache Redis"<br>}</pre> | no |
| multi\_az\_enabled | Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored) | `bool` | `true` | no |
| name | Name for the Redis replication group i.e. UserObject | `string` | `"redis-devops"` | no |
| parameter | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "maxmemory-policy",<br>    "value": "allkeys-lru"<br>  }<br>]</pre> | no |
| redis\_auth\_token | The password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true. If specified must contain from 16 to 128 alphanumeric characters or symbols | `string` | `""` | no |
| redis\_ingress\_rules | n/a | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = string<br>    description = string<br>  }))</pre> | `[]` | no |
| redis\_maintenance\_window | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period | `string` | `"fri:08:00-fri:09:00"` | no |
| redis\_node\_type | Instance type to use for creating the Redis cache clusters | `string` | `"cache.m5.large"` | no |
| redis\_parameter\_group\_name | Name of the custom aws\_elasticache\_parameter\_group | `string` | n/a | yes |
| redis\_port | n/a | `number` | `6379` | no |
| redis\_secret\_name | n/a | `string` | `"redis-devops"` | no |
| redis\_snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.\* cache nodes | `number` | `0` | no |
| redis\_snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period | `string` | `"06:30-07:30"` | no |
| redis\_version | Redis version to use, defaults to 5.0.6 | `string` | `"5.0.6"` | no |
| snapshot\_arns | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my\_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| snapshot\_name | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource | `string` | `""` | no |
| subnet\_group\_name | name of the subnet group | `string` | `"redis-devops"` | no |
| subnet\_ids | ID | `list(string)` | <pre>[<br>  "subnet-00e18ad0f2b2b4715",<br>  "subnet-09eb1fe49c63f4a56",<br>  "subnet-0fd3860d518971a49"<br>]</pre> | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(any)` | `{}` | no |
| transit\_encryption\_enabled | Whether to enable encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis | `bool` | `true` | no |
| vpc\_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | `string` | `"vpc-045ca1e2a3863bccf"` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | Redis primary endpoint |
| id | n/a |
| parameter\_group | n/a |
| port | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
