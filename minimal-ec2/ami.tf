# Search for ami id
data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  # Amazon Linux 2 
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20250428.0-arm64-gp2*"]
  }

  # correct arch for Graviton (ARM)
  filter {
    name   = "architecture"
    values = ["arm64"]
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

# Search for Ubuntu ami id
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  # Ubuntu 22.04 for ARM (Graviton)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_ids = {
    amazon_linux = data.aws_ami.amazon.id
    ubuntu       = data.aws_ami.ubuntu.id
  }
}