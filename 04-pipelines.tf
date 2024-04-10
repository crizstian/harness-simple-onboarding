resource "harness_platform_pipeline" "pipeline" {
  identifier = "full_ci_cd"
  org_id     = harness_platform_organization.this.identifier
  project_id = harness_platform_project.this.identifier
  name       = "Full Deployment Kubernetes"

  yaml = templatefile("./pipelines/full-deploymet.tftpl", {
    identifier           = "full_ci_cd"
    name                 = "Full Deployment Kubernetes"
    org_id               = harness_platform_organization.this.identifier
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
