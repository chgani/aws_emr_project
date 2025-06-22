variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "input_bucket_name" {
  description = "Name for the input data bucket"
  type        = string
}

variable "output_bucket_name" {
  description = "Name for the output data bucket"
  type        = string
}

variable "scripts_bucket_name" {
  description = "Name for the scripts bucket"
  type        = string
}

variable "python_script_path" {
  description = "Local filesystem path to the Python processing script"
  type        = string
}

variable "input_data_path" {
  description = "Local directory path containing input data files"
  type        = string
}