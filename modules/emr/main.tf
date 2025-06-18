# EMR cluster configuration
resource "aws_emr_cluster" "cluster" {
  name          = "data-processing-cluster-${var.environment}"
  release_label = "emr-7.9.0" # latest EMR version with Spark (we can mention the versions available in console)
  applications  = ["Spark"]   # Frameworks to install, we can add whatever we want which are available like hive, hadoop etc.,
  
  log_uri = "s3://${var.logs_bucket_name}/logs/" # Cluster logs location

  # Auto-terminate after processing
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = false

  # EC2 instance configuration
  ec2_attributes {
    instance_profile                  = var.emr_ec2_instance_profile_name
  }

  # Master node configuration
  master_instance_group {
    instance_type = var.master_instance_type
  }

  # Worker nodes configuration
  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count
  }

  service_role = var.emr_service_role_arn # IAM role for EMR service

  # Processing step definition
  step {
    action_on_failure = "TERMINATE_CLUSTER" # Destroy cluster if job fails
    name             = "Process Data"

    hadoop_jar_step {
      jar = "command-runner.jar" # EMR built-in utility
      args = [
        "spark-submit",
        "--deploy-mode", "cluster", # Run in cluster mode
        var.python_script_s3_path,  # Our processing script
        "--input", "s3://${var.input_bucket_name}/input/",  # Input path
        "--output", "s3://${var.output_bucket_name}/output/" # Output path
      ]
    }
  }

  tags = {
    Name        = "EMR Cluster"
    Environment = var.environment
  }
}