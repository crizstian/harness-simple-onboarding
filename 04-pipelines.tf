resource "harness_platform_pipeline" "pipeline" {
  identifier = "pipeline_cicd"
  org_id     = var.org_id
  project_id = harness_platform_project.this.identifier
  name       = "Full Deployment Kubernetes"

  yaml = templatefile("./pipelines/full-deploymet.tftpl", {
    identifier  = "pipeline_cicd"
    name        = "Pipeline Kubernetes Java"
    org_id      = var.org_id
    project_id  = harness_platform_project.this.identifier
    github_repo = "harness-cie-lab"
    gcs_bucket  = "crizstian-terraform"
    service_id  = harness_platform_service.this.identifier
  })
}
