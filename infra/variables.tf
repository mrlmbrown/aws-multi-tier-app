variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "my_ip" {
  description = "Your IP address for SSH access (format: x.x.x.x/32)"
  type        = string
}
