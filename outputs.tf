output "spark_operator" {
  value       = try(helm_release.spark_operator[0].metadata, null)
  description = "Spark Operator Helm Chart metadata"
}

output "yunikorn" {
  value       = try(helm_release.yunikorn[0].metadata, null)
  description = "Yunikorn Helm Chart metadata"
}

output "prometheus" {
  value       = try(helm_release.prometheus[0].metadata, null)
  description = "Prometheus Helm Chart metadata"
}

output "kubecost" {
  value       = try(helm_release.kubecost[0].metadata, null)
  description = "Kubecost Helm Chart metadata"
}

output "spark_history_server" {
  value       = try(helm_release.spark_history_server[0].metadata, null)
  description = "Spark History Server Helm Chart metadata"
}

output "jupyterhub" {
  value       = try(helm_release.jupyterhub[0].metadata, null)
  description = "jupyterhub Helm Chart metadata"
}

output "emr_spark_operator" {
  value       = try(helm_release.emr_spark_operator[0], null)
  description = "EMR Spark Operator Helm Chart metadata"
}

output "flink_operator" {
  value       = try(helm_release.flink_operator[0], null)
  description = "Flink Operator Helm Chart metadata"
}
output "nvidia_gpu_operator" {
  value       = try(helm_release.nvidia_gpu_operator[0], null)
  description = "NVIDIA GPU Operator Helm Chart metadata"
}
