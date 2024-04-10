resource "harness_platform_service" "this" {
  identifier  = "payment_service"
  name        = "payment-service"
  description = "connector provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
  org_id      = harness_platform_organization.this.identifier
  project_id  = harness_platform_project.this.identifier

  yaml = <<-EOT
service:
  name: payment-service
  identifier: payment_service
  orgIdentifier: ${harness_platform_organization.this.identifier}
  projectIdentifier: ${harness_platform_project.this.identifier}
  gitOpsEnabled: false
  serviceDefinition:
    type: Kubernetes
    spec:
      manifests:
        - manifest:
            identifier: manifiesto
            type: K8sManifest
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.${harness_platform_connector_github.this.identifier}
                  gitFetchType: Branch
                  paths:
                    - harness-deploy/payment-service-dev
                  repoName: harness-cie-lab
                  branch: main
              valuesPaths: <+input>
              skipResourceVersioning: false
              enableDeclarativeRollback: false
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.${harness_platform_connector_docker.this.identifier}
                imagePath: crizstian/payment-service-workshop
                tag: <+input>
                digest: ""
              identifier: Docker
              type: DockerRegistry
    EOT
}

# resource "harness_platform_monitored_service" "this" {
#   org_id     = harness_platform_organization.this.identifier
#   project_id = harness_platform_project.this.identifier
#   identifier = harness_platform_service.this.identifier
#   request {
#     name            = "payment-service"
#     type            = "Application"
#     description     = "monitor provisioned by terraform"
#     service_ref     = harness_platform_service.this.identifier
#     environment_ref = harness_platform_environment.this.identifier
#     tags            = ["owner:cristian.ramirez@harness.io"]
#     health_sources {
#       name       = "prometheus metrics verify step"
#       identifier = "prometheus_metrics"
#       type       = "Prometheus"
#       spec = jsonencode({
#         connectorRef = harness_platform_connector_prometheus.this.identifier
#         feature      = "apm"
#         metricDefinitions = [
#           {
#             identifier = "prometheus_metric"
#             metricName = "Prometheus Metric"
#             riskProfile = {
#               category     = "Infrastructure"
#               metricType   = "INFRA"
#               riskCategory = "Infrastructure"
#               thresholdTypes = [
#                 "ACT_WHEN_HIGHER"
#               ]
#             }
#             analysis = {
#               liveMonitoring = {
#                 enabled = false
#               }
#               deploymentVerification = {
#                 enabled                  = true
#                 serviceInstanceFieldName = "pod"
#               }
#               riskProfile = {
#                 category     = "Infrastructure"
#                 metricType   = "INFRA"
#                 riskCategory = "Infrastructure"
#                 thresholdTypes = [
#                   "ACT_WHEN_HIGHER"
#                 ]
#               }
#             }
#             sli = {
#               enabled = true
#             }
#             query                    = "avg(node_cpu_seconds_total{namespace=\"default\"namespace=\"default\"})"
#             groupName                = "memory"
#             serviceInstanceFieldName = "pod"
#             prometheusMetric         = "node_cpu_seconds_total"
#             serviceFilter = [
#               {
#                 labelName  = "namespace"
#                 labelValue = "default"
#               }
#             ]
#             envFilter = [
#               {
#                 labelName  = "namespace"
#                 labelValue = "default"
#               }
#             ]
#             aggregation   = "avg"
#             isManualQuery = false
#           }
#         ]
#         # Below section is for adding your own custom thresholds
#         metricPacks = [
#           {
#             identifier       = "Custom"
#             metricThresholds = []
#           }
#         ]
#       })
#     }
#   }
# }
