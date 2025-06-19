# force_destroy to true is optional (by defaults it is true) ,if we want delete the bucket as well after running terraform destroy command
# Input bucket for raw/source data
resource "aws_s3_bucket" "input_bucket" {
  bucket = var.input_bucket_name
  force_destroy = true

  tags = {
    Name        = "Input data bucket"
    Environment = var.environment
  }
}

# Output bucket for processed results
resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket_name
  force_destroy = true
  tags = {
    Name        = "Output data bucket"
    Environment = var.environment
  }
}

# bucket to save script for processing spark job
resource "aws_s3_bucket" "scripts_bucket" {
  bucket = var.scripts_bucket_name
  force_destroy = true 

  tags = {
    Name        = "Scripts bucket"
    Environment = var.environment
  }
}

# Upload processing script to S3
resource "aws_s3_object" "python_script" {
  bucket = aws_s3_bucket.scripts_bucket.id
  key    = "scripts/run_job.py"
  source = var.python_script_path
  etag   = filemd5(var.python_script_path)
}

# Upload all files from resources directory to input bucket
resource "aws_s3_object" "input_data" {
  bucket = aws_s3_bucket.input_bucket.id
  key    = "input/data.csv" 
  source = "${var.input_data_path}/data.csv"
}
