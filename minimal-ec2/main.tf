
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


data "aws_availability_zones" "available" {}

data "aws_vpc" "default" {
  default = true
}


data "aws_subnet" "first" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = data.aws_vpc.default.id
}

locals {
  ami_id    = local.ami_ids[var.operating_system]
  subnet_id = var.subnet_id != "" ? var.subnet_id : data.aws_subnet.first.id
  vpc_id    = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id
}


# IAM Role for EC2 to access S3
resource "aws_iam_role" "iam_ec2_role" {

  name = "${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.instance_name}-instance-profile"
  role = aws_iam_role.iam_ec2_role.name
}

# Resource: Launch Template for EC2
resource "aws_launch_template" "this" {
  name_prefix   = "minimal-ec2"
  description   = "Launch template for EC2 instance"
  image_id      = local.ami_id
  instance_type = var.instance_type

  user_data = base64encode(templatefile("./${path.module}/templates/userdata.tpl", {
    user_script = var.user_data
  }))

  network_interfaces {
    subnet_id                   = local.subnet_id
    associate_public_ip_address = var.associate_public_ip
    security_groups             = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = var.instance_name
      }
    )
  }
  dynamic "instance_market_options" {
    for_each = var.spot_instance ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        spot_instance_type = "one-time"
      }
    }
  }
}


# Resource: EC2 Instance using the Launch Template
resource "aws_instance" "this" {
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}
