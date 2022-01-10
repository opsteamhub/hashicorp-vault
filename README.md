### Hashicorp Vault provisioned by terraform in AWS Elastic Container Service

##### The DynamoDB storage backend is used to persist Vault's data in DynamoDB table.

#### Resources

| Name | Type |
|------|------|
| [aws_launch_configuration](./autoscaling.tf) | resource |
| [aws_autoscaling_group](./autoscaling.tf) | resource |
| [aws_cloudwatch_log_group](./cloudwatch_logs.tf) | resource |
| [aws_ecs_cluster](./ecs.tf) | resource |
| [aws_ecs_service](./ecs_service.tf) | resource |
| [aws_iam_policy](./iam.tf) | resource |
| [aws_iam_policy_document](./iam.tf) | data source |
| [aws_iam_role](./iam.tf) | resource |
| [aws_iam_role_policy_attachment](./iam.tf) | resource |
| [aws_iam_instance_profile](./iam.tf) | resource |
| [aws_kms_key](./kms.tf) | resource |
| [aws_kms_alias](./kms.tf) | resource |
| [aws_lb_target_group](./loadbalancer.tf) | resource |
| [aws_lb](./loadbalancer.tf) | resource |
| [aws_lb_listener](./loadbalancer.tf) | resource |
| [aws_security_group](./security_groups.tf) | resource |
| [aws_vpc](./subnets.tf) | data source |
| [aws_subnet_ids](./subnets.tf) | data source |
| [aws_ecs_task_definition](./task_definition.tf) | data source |


#### Inputs terraform.tfvars

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="vault_name"></a> [vault_name](#vault\_name) | Set name Vault. | `string` | `null` | yes |
| <a name="instance_type_vault"></a> [instance_type_vault](#instance\_type\_vault) | Set Instance Type Auto Scaling Group. | `string` | `null` | yes |
| <a name="key_name"></a> [key_name](#key\_name) | Key pair instance EC2. | `string` | `null` | yes |
| <a name="image_vault"></a> [image_vault](#image\_vault) | Vault docker image. | `string` | `null` | yes |
| <a name="disable_mlock"></a> [disable_mlock](#disable\_mlock) | Disable mlock in vault. | `string` | `null` | yes |
| <a name="backend_bucket_s3"></a> [backend_bucket_s3](#backend\_bucket\_s3) | Bucket Name used backend in vault.  | `string` | `null` | yes |
| <a name="seal_type"></a> [seal_type](#seal\_type) | Seal type to unseal vault.  | `string` | `null` | yes |
| <a name="certificate"></a> [certificate](#certificate) | SSL Certificate config in Load Balancer.  | `string` | `null` | yes |
| <a name="zone_id"></a> [zone_id](#zone\_id) | Hosted zone ID domain name in hosted zones Route 53.  | `string` | `null` | yes |
| <a name="dns_record"></a> [dns_record](#dns\_record) | Record name in record route 53 .  | `string` | `null` | yes |
| <a name="private_lb"></a> [private_lb](#private\_lb) | Private Load Balancer true or false.  | `bool` | `true` | no |
| <a name="environment"></a> [environment](#environment) | Tag data source VPC. Tag Key=Env,Value=prd.  | `string` | `null` | yes |
| <a name="subnet_tag_priv"></a> [subnet_tag_priv](#subnet\_tag_priv) | Tag private subnet in vpc. Tag Key=Env,Value=priv in subnet.  | `string` | `null` | yes |
| <a name="subnet_tag_pub"></a> [subnet_tag_pub](#subnet\_tag_pub) | Tag public subnet in vpc. Tag Key=Env,Value=pub in subnet.   | `string` | `null` | yes |
| <a name="memory"></a> [memory](#memory) | Memory size in task ecs.  | `number` | `1024` | no |
| <a name="cpu"></a> [cpu](#cpu) | CPU size in task ecs.  | `number` | `0` | no |
| <a name="memory"></a> [memory](#memory) | Memory size in task ecs.  | `number` | `1024` | no |
| <a name="desired_task_count"></a> [desired_task_count](#desired\_task\_count) | Desired task count in ecs service.  | `number` | `1` | no |
| <a name="desired_capacity"></a> [desired_capacity](#desired\_capacity) | Desired capacity in autoscaling group.  | `number` | `1` | no |
| <a name="min_size"></a> [min_size](#min\_size) | Min Size in autoscaling group.  | `number` | `1` | no |
| <a name="max_size"></a> [max_size](#max\_size) | Max Size in autoscaling group.  | `number` | `3` | no |
| <a name="squad"></a> [squad](#squad) | Tag Squad Owner.  | `string` | `untagged` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="lb_vault"></a> [lb\_vault](#lb\_vault) | DNS name Elastic Load Balancer Network. |

