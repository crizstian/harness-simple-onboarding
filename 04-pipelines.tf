resource "harness_platform_pipeline" "pipeline" {
  identifier = "pipeline_cicd"
  org_id     = var.org_id
  project_id = harness_platform_project.this.identifier
  name       = "Full Deployment Kubernetes"

  yaml = templatefile("./pipelines/full-deploymet.tftpl", {
    identifier           = "pipeline_cicd"
    name                 = "Pipeline Kubernetes Java"
    org_id               = var.org_id
    project_id           = harness_platform_project.this.identifier
    github_connector     = "account.${harness_platform_connector_github.this.identifier}"
    github_repo          = "harness-cie-lab"
    build_infrastructure = "account.${harness_platform_connector_kubernetes.build.identifier}"
    gcp_connector        = "account.${harness_platform_connector_gcp.this.identifier}"
    gcs_bucket           = "crizstian-terraform"
    docker_connector     = "account.${harness_platform_connector_docker.this.identifier}"
    service_id           = harness_platform_service.this.identifier
    jira_connector       = "account.${harness_platform_connector_jira.this.identifier}"
  })
}
