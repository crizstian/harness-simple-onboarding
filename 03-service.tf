resource "harness_platform_service" "this" {
  identifier  = "helm_ms_sgi_login_service"
  name        = "helm_ms_sgi_login_service"
  description = "connector provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
  org_id      = harness_platform_organization.this.identifier
  project_id  = harness_platform_project.this.identifier

  yaml = <<-EOT
service:
  name: helm_ms_sgi_login_service
  identifier: helm_ms_sgi_login_service
  orgIdentifier: ${harness_platform_organization.this.identifier}
  projectIdentifier: ${harness_platform_project.this.identifier}
  serviceDefinition:
    spec:
      manifests:
        - manifest:
            identifier: cicd_gar
            type: HelmChart
            spec:
              store:
                type: GitLab
                spec:
                  connectorRef: account.tecnomedia
                  gitFetchType: Branch
                  folderPath: /ms-sgi-login
                  repoName: tcmd/helm_charts
                  branch: develop
              subChartPath: ""
              valuesPaths: <+input>
              skipResourceVersioning: false
              enableDeclarativeRollback: false
              helmVersion: V3
              fetchHelmChartMetadata: false
              commandFlags:
                - commandType: Install
                  flag: "-n sgi"
      artifacts:
        primary:
          primaryArtifactRef: cicd_gar
          sources:
            - identifier: cicd_gar
              spec:
                connectorRef: account.prosagcp
                repositoryType: docker
                project: ci-cd-prj-tools-01
                region: us-central1
                repositoryName: sandbox
                package: ms-sgi-login
                version: <+pipeline.stages.Building.spec.execution.steps.Build_Push_Container_Image.artifact_Build_Push_Container_Image.stepArtifacts.publishedImageArtifacts[0].tag>
                digest: ""
              type: GoogleArtifactRegistry
      variables:
        - name: releaseChart
          type: String
          description: ""
          required: false
          value: ms-sgi-login
    type: NativeHelm
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
