# # resource "harness_platform_connector_kubernetes" "build" {
# #   identifier  = "cristian_kubernetes_cluster"
# #   name        = "cristian_kubernetes_cluster"
# #   description = "connector provisioned by terraform"
# #   tags        = ["owner:cristian.ramirez@harness.io"]

# #   inherit_from_delegate {
# #     delegate_selectors = ["ci-cd-gke-cluster"]
# #   }
# # }

# # resource "harness_platform_connector_kubernetes" "dev" {
# #   identifier  = "cristian_k8s_dev_cluster"
# #   name        = "cristian_k8s_dev_cluster"
# #   description = "connector provisioned by terraform"
# #   tags        = ["owner:cristian.ramirez@harness.io"]

# #   service_account {
# #     master_url                = "https://kubernetes.example.com"
# #     service_account_token_ref = "account.cristian_eks_dev_cluster_token"
# #   }
# #   delegate_selectors = ["ci-cd-gke-cluster"]
# # }

# resource "harness_platform_connector_github" "this" {
#   identifier  = "cristian_github"
#   name        = "Cristian Github"
#   description = "connector provisioned by terraform"
#   tags        = ["owner:cristian.ramirez@harness.io"]

#   url                = "https://github.com/crizstian"
#   connection_type    = "Account"
#   validation_repo    = "IDP-Test"
#   delegate_selectors = ["ci-cd-gke-cluster"]
#   credentials {
#     http {
#       username  = "crizstian"
#       token_ref = "account.cristian_github_token"
#     }
#   }
# }

# # resource "harness_platform_connector_gcp" "this" {
# #   identifier  = "cristian_GCP"
# #   name        = "Cristian GCP"
# #   description = "connector provisioned by terraform"
# #   tags        = ["owner:cristian.ramirez@harness.io"]

# #   inherit_from_delegate {
# #     delegate_selectors = ["ci-cd-gke-cluster"]
# #   }
# # }

# resource "harness_platform_connector_docker" "this" {
#   identifier  = "cristian_docker"
#   name        = "Cristian Docker"
#   description = "connector provisioned by terraform"
#   tags        = ["owner:cristian.ramirez@harness.io"]

#   type               = "DockerHub"
#   url                = "https://hub.docker.com"
#   delegate_selectors = ["ci-cd-gke-cluster"]

#   credentials {
#     username     = "crizstian"
#     password_ref = "account.cristian_docker_token"
#   }
# }

# # resource "harness_platform_connector_jira" "this" {
# #   identifier  = "Harness_JIRA"
# #   name        = "Harness Jira"
# #   description = "connector provisioned by terraform"
# #   tags        = ["owner:cristian.ramirez@harness.io"]

# #   url                = "https://harness.atlassian.net"
# #   delegate_selectors = ["ci-cd-gke-cluster"]
# #   auth {
# #     auth_type = "UsernamePassword"
# #     username_password {
# #       username     = "cristian.ramirez@harness.io"
# #       password_ref = "account.cristian_jira_token"
# #     }
# #   }
# # }

# # resource "harness_platform_connector_prometheus" "this" {
# #   identifier  = "cristian_prometheus"
# #   name        = "Cristian Prometheus"
# #   description = "connector provisioned by terraform"
# #   tags        = ["owner:cristian.ramirez@harness.io"]

# #   url                = "http://prometheus.selatam.harness-demo.site/"
# #   delegate_selectors = ["ci-cd-gke-cluster"]
# # }
