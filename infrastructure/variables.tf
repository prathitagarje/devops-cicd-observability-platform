# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
  default     = "m7i-flex.large"
}

# AMI ID
variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2 recommended)"
  type        = string
  default     = "ami-0ed094fb1304fd857" # Amazon Linux 2 in us-east-1
}

# Allowed SSH CIDR
variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to access EC2 via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict in production
}

# Allowed HTTP (Jenkins UI) CIDR
variable "allowed_http_cidr" {
  description = "CIDR blocks allowed to access Jenkins UI (port 8080)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict in production
}

# 🏷️ Environment Tag
variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "dev"
}