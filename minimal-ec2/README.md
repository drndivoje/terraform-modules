## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ec2_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.iam_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.amazon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnet.first](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for the EC2 instance. If not provided, it will be determined based on the operating system. | `string` | `""` | no |
| <a name="input_associate_public_ip"></a> [associate\_public\_ip](#input\_associate\_public\_ip) | Whether to associate a public IP address with the instance. | `bool` | `true` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name tag for the EC2 instance. | `string` | `"deploy-instance"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The EC2 instance type. | `string` | `"t4g.nano"` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The operating system for the EC2 instance. Possible values are 'ubuntu', 'amazon-linux', or 'centos'. | `string` | `"ubuntu"` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Security group ID to attach to the EC2 instance. | `string` | n/a | yes |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Whether to use a spot instance. | `bool` | `true` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet where the EC2 instance will be deployed. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data script to run on the instance. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the EC2 instance will be deployed. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_instance_url"></a> [ec2\_instance\_url](#output\_ec2\_instance\_url) | The URL of the EC2 instance |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | IAM role attached to the EC2 instance. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the created EC2 instance. |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the EC2 instance. |
