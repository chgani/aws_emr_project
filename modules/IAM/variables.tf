variable "environment" {
  description = "Environment name for resource naming"
  type        = string
}

variable "input_bucket_name" {
  description = "Name of the input S3 bucket"
  type        = string
}

variable "output_bucket_name" {
  description = "Name of the output S3 bucket"
  type        = string
}

variable "scripts_bucket_name" {
  description = "Name of the scripts S3 bucket"
  type        = string
}