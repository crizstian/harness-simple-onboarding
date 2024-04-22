resource "harness_platform_pipeline" "pipeline" {
  identifier = "gitops_pipeline"
  org_id     = harness_platform_organization.this.identifier
  project_id = harness_platform_project.this.identifier
  name       = "Full GitOps"

  yaml = templatefile("./pipelines/gitops-pipeline.tftpl", {
    identifier           = "gitops_pipeline"
    name                 = "Full GitOps"
    org_id               = harness_platform_organization.this.identifier
    project_id           = harness_platform_project.this.identifier
    github_connector     = "account.${harness_platform_connector_github.this.identifier}"
    github_repo          = "guestbook-delivery"
    build_infrastructure = "account.${harness_platform_connector_kubernetes.build.identifier}"
    docker_connector     = "account.${harness_platform_connector_docker.this.identifier}"
    service_id           = harness_platform_service.this.identifier
  })
}
