resource "harness_platform_service" "this" {
  identifier  = "GuestBook_UI"
  name        = "GuestBook - UI"
  description = "connector provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
  org_id      = harness_platform_organization.this.identifier
  project_id  = harness_platform_project.this.identifier

  yaml = <<-EOT
service:
  name: GuestBook - UI
  identifier: GuestBook_UI
  orgIdentifier: ${harness_platform_organization.this.identifier}
  projectIdentifier: ${harness_platform_project.this.identifier}
  serviceDefinition:
    spec:
      variables:
        - name: harness_service
          type: String
          description: ""
          required: false
          value: "<+service.identifier>"
        - name: environment
          type: String
          description: ""
          required: false
          value: " <+env.name>"
        - name: image_tag
          type: String
          description: ""
          required: false
          value: " <+pipeline.stages.Build_Test_Push.spec.execution.steps.Create_Tag.output.outputVariables.TAG>"
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.cristian_docker
                imagePath: crizstian/guestbook
                tag: latest
                digest: ""
              identifier: guestbook
              type: DockerRegistry
      manifests:
        - manifest:
            identifier: config
            type: ReleaseRepo
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.cristian_github
                  gitFetchType: Branch
                  paths:
                    - cluster-config/<+cluster.name>/config.json
                  branch: main
                  repoName: guestbook-delivery
        - manifest:
            identifier: appset
            type: DeploymentRepo
            spec:
              store:
                type: Github
                spec:
                  connectorRef: account.cristian_github
                  gitFetchType: Branch
                  paths:
                    - appset/applicationset.yaml
                  branch: main
                  repoName: guestbook-delivery
    type: Kubernetes
  gitOpsEnabled: true

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
