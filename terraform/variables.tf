variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Machine Image ID (Ubuntu 22.04)"
  default     = "ami-0e1bed4f06a3b463d"  # Ubuntu 22.04 in us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.small"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "EC2-AMI-Aks-HV"
}

variable "mongodb_port" {
  description = "MongoDB port"
  default     = 27017
}

variable "backend_port" {
  description = "Backend application port"
  default     = 5000
}

variable "frontend_port" {
  description = "Frontend application port"
  default     = 3000
}

variable "db_username" {
  description = "MongoDB username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "MongoDB password"
  type        = string
  sensitive   = true
}