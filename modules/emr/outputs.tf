output "cluster_id" {
  description = "ID of the created EMR cluster"
  value       = aws_emr_cluster.cluster.id
}