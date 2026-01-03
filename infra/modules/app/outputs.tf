output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.app_lt.id
}

output "app_security_group_id" {
  description = "Security group ID of the app instances"
  value       = aws_security_group.app_sg.id
}
