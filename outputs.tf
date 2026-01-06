output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.web.alb_dns_name
}

output "db_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}
