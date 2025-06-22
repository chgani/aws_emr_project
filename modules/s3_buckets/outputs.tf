output "input_bucket_name" {
  description = "Name of the created input bucket"
  value       = aws_s3_bucket.input_bucket.id
}

output "output_bucket_name" {
  description = "Name of the created output bucket"
  value       = aws_s3_bucket.output_bucket.id
}

output "scripts_bucket_name" {
  description = "Name of the created scripts bucket"
  value       = aws_s3_bucket.scripts_bucket.id
}

output "python_script_s3_path" {
  description = "Full S3 path to the uploaded Python script"
  value       = "s3://${aws_s3_bucket.scripts_bucket.id}/scripts/run_job.py"
}