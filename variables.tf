variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-multi-tier-app"
}

variable "db_password" {
  description = "Database password (sensitive)"
  type        = string
  sensitive   = true
}
