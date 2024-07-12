resource "harness_platform_pipeline" "pipeline" {
  identifier = "full_deployment"
  org_id     = harness_platform_organization.this.identifier
  project_id = harness_platform_project.this.identifier
  name       = "Full deployment"

  yaml = templatefile("./pipelines/full-deploymet.tftpl", {
    identifier           = "full_deployment"
    name                 = "Full deployment"
    org_id               = harness_platform_organization.this.identifier
    project_id           = harness_platform_project.this.identifier
    github_connector     = "account.${harness_platform_connector_github.this.identifier}"
    github_repo          = "guestbook-delivery"
    build_infrastructure = "account.cicdgkecluster"
    docker_connector     = "account.${harness_platform_connector_docker.this.identifier}"
    service_id           = harness_platform_service.this.identifier
    gcs_bucket           = "test"
    gcp_connector        = "account.prosagcp"
    jira_connector       = "test"
  })
}
