output "airflow" {
  value       = try(helm_release.airflow[0].metadata, null)
  description = "Airflow Helm Chart metadata"
}

output "aws_efa_k8s_device_plugin" {
  value       = try(helm_release.aws_efa_k8s_device_plugin, null)
  description = "AWS EFA K8s Plugin Helm Chart metadata"
}

output "aws_neuron_device_plugin" {
  value       = try(helm_release.aws_neuron_device_plugin, null)
  description = "AWS Neuron Device Plugin Helm Chart metadata"
}

output "emr_spark_operator" {
  value       = try(helm_release.emr_spark_operator[0].metadata, null)
  description = "EMR Spark Operator Helm Chart metadata"
}

output "flink_operator" {
  value       = try(helm_release.flink_operator[0].metadata, null)
  description = "Flink Operator Helm Chart metadata"
}

output "jupyterhub" {
  value       = try(helm_release.jupyterhub[0].metadata, null)
  description = "Jupyterhub Helm Chart metadata"
}

output "kubecost" {
  value       = try(helm_release.kubecost[0].metadata, null)
  description = "Kubecost Helm Chart metadata"
}

output "nvidia_gpu_operator" {
  value       = try(helm_release.nvidia_gpu_operator[0].metadata, null)
  description = "Nvidia GPU Operator Helm Chart metadata"
}

output "spark_history_server" {
  value       = try(helm_release.spark_history_server[0].metadata, null)
  description = "Spark History Server Helm Chart metadata"
}

output "spark_operator" {
  value       = try(helm_release.spark_operator[0].metadata, null)
  description = "Spark Operator Helm Chart metadata"
}

output "strimzi_kafka_operator" {
  value       = try(helm_release.strimzi_kafka_operator[0].metadata, null)
  description = "Strimzi Kafka Operator Helm Chart metadata"
}

output "yunikorn" {
  value       = try(helm_release.yunikorn[0].metadata, null)
  description = "Yunikorn Helm Chart metadata"
}
