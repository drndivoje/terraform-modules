
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Search for ami id
data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  # Amazon Linux 2 optimised ECS instance
  filter {
    name   = "name"
    values = ["al2023-ami-2023.6*"]
  }

  # correct arch
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # Owned by Amazon
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {}

data "aws_subnet" "first" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = var.vpc_id
}

locals {
  ami_id    = data.aws_ami.amazon.id
  subnet_id = var.subnet_id != "" ? var.subnet_id : data.aws_subnet.first.id

}

# IAM Role for EC2 to access S3
resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

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

# IAM Policy for S3 Bucket Access
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "s3-bucket-policy"
  description = "Policy to allow access to specific S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.s3_access_role.name
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
}


# Resource: EC2 Instance using the Launch Template
resource "aws_instance" "this" {
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name


  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}
