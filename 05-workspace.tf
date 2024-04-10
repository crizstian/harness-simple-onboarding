variable "harness_platform_workspaces" {
  default = {
    "gke-ecomm-dev" = {
      enable                  = true
      repository              = "terraform-gke"
      repository_branch       = "refactor"
      repository_path         = "provision"
      cost_estimation_enabled = true
      provider_connector      = "account.cristian_gcp_gcp_connector_MQTH"
      repository_connector    = "account.cristian_github_github_connector_MQTH"

      terraform_variable = {
        "gcp_machine_type" = {
          key        = "gcp_machine_type"
          value      = "n1-standard-16"
          value_type = "string"
        }
        "gke_num_nodes" = {
          key        = "gke_num_nodes"
          value      = "4"
          value_type = "string"
        }
        "gcp_network" = {
          key        = "gcp_network"
          value      = "default"
          value_type = "string"
        }
        "gke_cluster_name" = {
          key        = "gke_cluster_name"
          value      = "gke-ecomm-dev"
          value_type = "string"
        }
      }
      environment_variable = {
        #   "HARNESS_ACCOUNT_ID" = {
        #     key        = "HARNESS_ACCOUNT_ID"
        #     value      = "<+account.identifier>"
        #     value_type = "string"
        #   }
        #   "HARNESS_PLATFORM_API_KEY" = {
        #     key        = "HARNESS_PLATFORM_API_KEY"
        #     value      = "account.HSA"
        #     value_type = "secret"
        #   }
        "PLUGIN_INIT_BACKEND_CONFIG_1" = {
          key        = "PLUGIN_INIT_BACKEND_CONFIG_1"
          value      = "bucket=crizstian-terraform"
          value_type = "string"
        }
        "PLUGIN_INIT_BACKEND_CONFIG_2" = {
          key        = "PLUGIN_INIT_BACKEND_CONFIG_2"
          value      = "prefix=terraform-gke/infrastructure_team/gke-ecomm-dev"
          value_type = "string"
        }
      }
    }
  }
}

locals {
  workspaces = { for name, details in var.harness_platform_workspaces : name => merge(
    details,
    {
      identifier              = "${lower(replace(name, "/[\\s-.]/", "_"))}"
      terraform_variable      = try(details.terraform_variable, {})
      environment_variable    = try(details.environment_variable, {})
      terraform_variable_file = try(details.terraform_variable_file, {})
    }
  ) if details.enable }
}

resource "harness_platform_workspace" "workspace" {
  for_each                = local.workspaces
  name                    = each.key
  identifier              = each.value.identifier
  org_id                  = harness_platform_organization.this.identifier
  project_id              = harness_platform_project.this.identifier
  provisioner_type        = "terraform"
  provisioner_version     = "1.5.6"
  repository              = each.value.repository
  repository_branch       = each.value.repository_branch
  repository_path         = each.value.repository_path
  cost_estimation_enabled = each.value.cost_estimation_enabled
  provider_connector      = each.value.provider_connector
  repository_connector    = each.value.repository_connector

  dynamic "terraform_variable" {
    for_each = each.value.terraform_variable
    content {
      key        = terraform_variable.value.key
      value      = terraform_variable.value.value
      value_type = terraform_variable.value.value_type
    }
  }

  dynamic "environment_variable" {
    for_each = each.value.environment_variable
    content {
      key        = environment_variable.value.key
      value      = environment_variable.value.value
      value_type = environment_variable.value.value_type
    }
  }

  dynamic "terraform_variable_file" {
    for_each = each.value.terraform_variable_file
    content {
      repository           = terraform_variable_file.value.repository
      repository_branch    = terraform_variable_file.value.repository_branch
      repository_path      = terraform_variable_file.value.repository_path
      repository_connector = terraform_variable_file.value.repository_connector
    }
  }
}
