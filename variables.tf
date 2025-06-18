variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1" # Default to N.Virginia
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev" # Default to development environment
}