output "emr_service_role_arn" {
  description = "ARN of the EMR service role"
  value       = aws_iam_role.emr_service_role.arn
}

output "emr_ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile for EMR"
  value       = aws_iam_instance_profile.emr_ec2_instance_profile.name
}