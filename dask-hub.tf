locals {
  daskhub_name          = "dask-hub"
  daskhub_chart_name    = "daskhub"
  daskhub_repo          = "https://helm.dask.org"
  daskhub_chart_version = try(var.daskhub_helm_config["version"], "2023.1.0")
}

resource "helm_release" "daskhub" {
  count = var.enable_daskhub ? 1 : 0

  name                       = try(var.daskhub_helm_config["name"], local.daskhub_name)
  repository                 = try(var.daskhub_helm_config["repository"], local.daskhub_repo)
  chart                      = try(var.daskhub_helm_config["chart"], local.daskhub_chart_name)
  version                    = local.dask_chart_version
  timeout                    = try(var.daskhub_helm_config["timeout"], 300)
  values                     = try(var.daskhub_helm_config["values"], null)
  create_namespace           = try(var.daskhub_helm_config["create_namespace"], true)
  namespace                  = try(var.daskhub_helm_config["namespace"], local.daskhub_name)
  lint                       = try(var.daskhub_helm_config["lint"], false)
  description                = try(var.daskhub_helm_config["description"], "")
  repository_key_file        = try(var.daskhub_helm_config["repository_key_file"], "")
  repository_cert_file       = try(var.daskhub_helm_config["repository_cert_file"], "")
  repository_username        = try(var.daskhub_helm_config["repository_username"], "")
  repository_password        = try(var.daskhub_helm_config["repository_password"], "")
  verify                     = try(var.daskhub_helm_config["verify"], false)
  keyring                    = try(var.daskhub_helm_config["keyring"], "")
  disable_webhooks           = try(var.daskhub_helm_config["disable_webhooks"], false)
  reuse_values               = try(var.daskhub_helm_config["reuse_values"], false)
  reset_values               = try(var.daskhub_helm_config["reset_values"], false)
  force_update               = try(var.daskhub_helm_config["force_update"], false)
  recreate_pods              = try(var.daskhub_helm_config["recreate_pods"], false)
  cleanup_on_fail            = try(var.daskhub_helm_config["cleanup_on_fail"], false)
  max_history                = try(var.daskhub_helm_config["max_history"], 0)
  atomic                     = try(var.daskhub_helm_config["atomic"], false)
  skip_crds                  = try(var.daskhub_helm_config["skip_crds"], false)
  render_subchart_notes      = try(var.daskhub_helm_config["render_subchart_notes"], true)
  disable_openapi_validation = try(var.daskhub_helm_config["disable_openapi_validation"], false)
  wait                       = try(var.daskhub_helm_config["wait"], true)
  wait_for_jobs              = try(var.daskhub_helm_config["wait_for_jobs"], false)
  dependency_update          = try(var.daskhub_helm_config["dependency_update"], false)
  replace                    = try(var.daskhub_helm_config["replace"], false)

  postrender {
    binary_path = try(var.daskhub_helm_config["postrender"], "")
  }

  dynamic "set" {
    iterator = each_item
    for_each = try(var.daskhub_helm_config["set"], [])

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    iterator = each_item
    for_each = try(var.daskhub_helm_config["set_sensitive"], [])

    content {
      name  = each_item.value.name
      value = each_item.value.value
      type  = try(each_item.value.type, null)
    }
  }

}
