locals {
  spark_history_server_name       = "spark-history-server"
  spark_history_server_repository = "https://kubedai.github.io/spark-history-server"
  spark_history_server_version    = "1.5.1"

  spark_history_server_service_account = "spark-history-server-sa"
  spark_history_server_create_irsa     = var.enable_spark_history_server && try(var.spark_history_server_helm_config.create_irsa, true)
  spark_history_server_namespace       = try(var.spark_history_server_helm_config["namespace"], local.spark_history_server_name)
  
  # Parse user values
  user_provided_values = try(yamldecode(var.spark_history_server_helm_config.values[0]), {})
  
  # Build the final configuration - always S3 for AWS, but preserve user's S3 config
  spark_history_server_values = yamlencode(merge(
    local.user_provided_values,
    {
      # Always set logStore type to S3 and add IRSA role ARN
      logStore = merge(
        try(local.user_provided_values.logStore, {}),
        {
          type = "s3"
          s3 = merge(
            try(local.user_provided_values.logStore.s3, {}),
            {
              # Chart handles ServiceAccount annotation automatically when this is set
              irsaRoleArn = local.spark_history_server_create_irsa ? module.spark_history_server_irsa[0].iam_role_arn : ""
            }
          )
        }
      )
    }
  ))
}

resource "helm_release" "spark_history_server" {
  count = var.enable_spark_history_server ? 1 : 0

  name             = try(var.spark_history_server_helm_config["name"], local.spark_history_server_name)
  repository       = try(var.spark_history_server_helm_config["repository"], local.spark_history_server_repository)
  chart            = try(var.spark_history_server_helm_config["chart"], local.spark_history_server_name)
  version          = try(var.spark_history_server_helm_config["version"], local.spark_history_server_version)
  namespace        = local.spark_history_server_namespace
  create_namespace = try(var.spark_history_server_helm_config["create_namespace"], true)
  
  values = [local.spark_history_server_values]

  # Essential deployment settings
  timeout         = try(var.spark_history_server_helm_config["timeout"], 300)
  wait           = try(var.spark_history_server_helm_config["wait"], true)
  atomic         = try(var.spark_history_server_helm_config["atomic"], true)
  cleanup_on_fail = try(var.spark_history_server_helm_config["cleanup_on_fail"], true)

  # Pass through other settings
  lint                       = try(var.spark_history_server_helm_config["lint"], false)
  description                = try(var.spark_history_server_helm_config["description"], "Spark History Server for AWS EKS")
  verify                     = try(var.spark_history_server_helm_config["verify"], false)
  disable_webhooks           = try(var.spark_history_server_helm_config["disable_webhooks"], false)
  reuse_values               = try(var.spark_history_server_helm_config["reuse_values"], false)
  reset_values               = try(var.spark_history_server_helm_config["reset_values"], false)
  force_update               = try(var.spark_history_server_helm_config["force_update"], false)
  recreate_pods              = try(var.spark_history_server_helm_config["recreate_pods"], false)
  max_history                = try(var.spark_history_server_helm_config["max_history"], 10)
  skip_crds                  = try(var.spark_history_server_helm_config["skip_crds"], false)
  render_subchart_notes      = try(var.spark_history_server_helm_config["render_subchart_notes"], true)
  disable_openapi_validation = try(var.spark_history_server_helm_config["disable_openapi_validation"], false)
  wait_for_jobs              = try(var.spark_history_server_helm_config["wait_for_jobs"], false)
  dependency_update          = try(var.spark_history_server_helm_config["dependency_update"], false)
  replace                    = try(var.spark_history_server_helm_config["replace"], false)

  postrender {
    binary_path = try(var.spark_history_server_helm_config["postrender"], "")
  }

  dynamic "set" {
    iterator = each_item
    for_each = try(var.spark_history_server_helm_config.set, [])

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    iterator = each_item
    for_each = try(var.spark_history_server_helm_config["set_sensitive"], [])

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }
}

#---------------------------------------------------------------
# IRSA for Spark History Server
#---------------------------------------------------------------
module "spark_history_server_irsa" {
  source = "./irsa"
  count  = local.spark_history_server_create_irsa ? 1 : 0

  create_role                   = try(var.spark_history_server_helm_config.create_role, true)
  role_name                     = try(var.spark_history_server_helm_config.role_name, local.spark_history_server_name)
  role_name_use_prefix          = try(var.spark_history_server_helm_config.role_name_use_prefix, true)
  role_path                     = try(var.spark_history_server_helm_config.role_path, "/")
  role_permissions_boundary_arn = try(var.spark_history_server_helm_config.role_permissions_boundary_arn, null)
  role_description              = try(var.spark_history_server_helm_config.role_description, "IRSA for ${local.spark_history_server_name}")

  role_policy_arns = try(var.spark_history_server_helm_config.role_policy_arns, {
    "S3ReadOnlyPolicy" = "arn:${local.partition}:iam::aws:policy/AmazonS3ReadOnlyAccess"
  })

  oidc_providers = {
    this = {
      provider_arn    = var.oidc_provider_arn
      namespace       = local.spark_history_server_namespace
      service_account = local.spark_history_server_service_account
    }
  }

  tags = try(var.spark_history_server_helm_config.tags, {})
}

