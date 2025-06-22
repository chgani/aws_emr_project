output "input_bucket_name" {
  description = "Name of the S3 bucket for input data"
  value       = module.s3.input_bucket_name
}

output "output_bucket_name" {
  description = "Name of the S3 bucket for processed output"
  value       = module.s3.output_bucket_name
}

output "scripts_bucket_name" {
  description = "Name of the S3 bucket for processing scripts"
  value       = module.s3.scripts_bucket_name
}

output "emr_cluster_id" {
  description = "ID of the created EMR cluster"
  value       = module.emr.cluster_id
}