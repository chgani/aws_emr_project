# IAM role for EMR service
resource "aws_iam_role" "emr_service_role" {
  name = "emr_service_role_${var.environment}"

  # When you create an IAM role for Amazon EMR, you need to allow the EMR service (elasticmapreduce.amazonaws.com) 
  # to assume that role. This is done using a trust policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "elasticmapreduce.amazonaws.com"
      }
    }]
  })
}

# Attach AWS managed policy for EMR service role
resource "aws_iam_role_policy_attachment" "emr_service_role_policy" {
  role       = aws_iam_role.emr_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

# IAM role for EC2 instances in the EMR cluster - this is critical because it grants each EC2 instance(nodes)
# to interact with the services if requires
resource "aws_iam_role" "emr_ec2_instance_role" {
  name = "emr_ec2_instance_role_${var.environment}"

  # When you create an IAM role for Amazon EC2, you need to allow the EC2 service (ec2.amazonaws.com) 
  # to assume that role. This is done using a trust policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Instance profile to attach the EC2 role to EMR instances - this is important beacuse roles cant be added to instances individually
resource "aws_iam_instance_profile" "emr_ec2_instance_profile" {
  name = "emr_ec2_instance_profile_${var.environment}"
  role = aws_iam_role.emr_ec2_instance_role.name
}

# Attach AWS managed policy for EC2 instances in EMR
resource "aws_iam_role_policy_attachment" "emr_ec2_instance_role_policy" {
  role       = aws_iam_role.emr_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

# policy to get the access to s3 buckets for data and dependencies (if any)
# attaches policy to emr_ec2_role
resource "aws_iam_role_policy" "emr_s3_access_policy" {
  name = "emr_s3_access_policy_${var.environment}"
  role = aws_iam_role.emr_ec2_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",   # Read objects
        "s3:PutObject",   # Write objects
        "s3:ListBucket"   # List bucket contents
      ],
      Resource = [
        "arn:aws:s3:::${var.input_bucket_name}",       # Input bucket
        "arn:aws:s3:::${var.input_bucket_name}/*",     # All objects in input bucket
        "arn:aws:s3:::${var.output_bucket_name}",      # Output bucket
        "arn:aws:s3:::${var.output_bucket_name}/*",    # All objects in output bucket
        "arn:aws:s3:::${var.scripts_bucket_name}",     # Scripts bucket
        "arn:aws:s3:::${var.scripts_bucket_name}/*"   # All objects in scripts bucket
      ]
    }]
  })
}