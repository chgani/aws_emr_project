# Configure AWS provider
provider "aws" {
  region = var.region # AWS region where resources will be created
}

# Generate random suffix for bucket names to ensure uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Create S3 buckets and upload data/scripts (if we want we can have the variable values in respective modules itself)
module "s3" {
  source = "./modules/s3_buckets"

  environment         = var.environment
  input_bucket_name   = "${var.environment}-input-bucket-${random_id.bucket_suffix.hex}"
  output_bucket_name  = "${var.environment}-output-bucket-${random_id.bucket_suffix.hex}"
  scripts_bucket_name = "${var.environment}-scripts-bucket-${random_id.bucket_suffix.hex}"
  python_script_path  = "${path.root}/scripts/run_job.py" # Local script path
  input_data_path     = "${path.root}/scripts/resources" # Local data directory
}

# Create IAM roles and policies needed for EMR
module "iam" {
  source = "./modules/iam"

  environment         = var.environment
  input_bucket_name   = module.s3.input_bucket_name
  output_bucket_name  = module.s3.output_bucket_name
  scripts_bucket_name = module.s3.scripts_bucket_name
}

# Create EMR cluster with Spark to process data
module "emr" {
  source = "./modules/emr"

  environment                    = var.environment
  emr_service_role_arn           = module.iam.emr_service_role_arn # From IAM module
  emr_ec2_instance_profile_name  = module.iam.emr_ec2_instance_profile_name
  python_script_s3_path          = module.s3.python_script_s3_path # From S3 module
  input_bucket_name              = module.s3.input_bucket_name
  output_bucket_name             = module.s3.output_bucket_name
  logs_bucket_name               = module.s3.scripts_bucket_name
}
