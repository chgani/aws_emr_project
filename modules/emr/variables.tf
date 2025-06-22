variable "environment" {
  description = "Environment name for resource naming"
  type        = string
}

variable "emr_service_role_arn" {
  description = "ARN of the IAM service role for EMR"
  type        = string
}

variable "emr_ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  type        = string
}

variable "master_instance_type" {
  description = "EC2 instance type for master node"
  type        = string
  default     = "m5.xlarge" # 4 vCPU, 16GB RAM
}

variable "core_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_count" {
  description = "Number of worker nodes in cluster"
  type        = number
  default     = 1
}

variable "python_script_s3_path" {
  description = "S3 path to the processing script"
  type        = string
}

variable "input_bucket_name" {
  description = "Name of the input data bucket"
  type        = string
}

variable "output_bucket_name" {
  description = "Name of the output data bucket"
  type        = string
}

variable "logs_bucket_name" {
  description = "Name of the bucket for cluster logs"
  type        = string
}