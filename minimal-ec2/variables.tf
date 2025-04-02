# Input: VPC ID
variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instance will be deployed."
  type        = string
  default = ""
}

# Input: Subnet ID
variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be deployed."
  type        = string
  default = ""
}

# Input: Security Group ID
variable "security_group_id" {
  description = "Security group ID to attach to the EC2 instance."
  type        = string
}

# Input: Instance Name
variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "deploy-instance"
}

# Input: Instance Type
variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t2.micro"
}

# Input: Associate Public IP
variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script to run on the instance."
  type        = string
}


variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "The AMI ID to use for the instance."
  type        = string
  default     = ""
  
}


# Input: Tags
variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
