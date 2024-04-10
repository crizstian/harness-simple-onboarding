resource "harness_platform_environment" "this" {
  identifier  = "DEV"
  name        = "DEV"
  type        = "PreProduction"
  description = "env provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
  org_id      = harness_platform_organization.this.identifier
  project_id  = harness_platform_project.this.identifier

  yaml = <<-EOT
environment:
  name: DEV
  identifier: DEV
  tags: {}
  type: PreProduction
  orgIdentifier: ${harness_platform_organization.this.identifier}
  projectIdentifier: ${harness_platform_project.this.identifier}
  variables: []
EOT
}

resource "harness_platform_infrastructure" "this" {
  identifier      = "gkeecommdev"
  name            = "gke-ecomm-dev"
  env_id          = "environmentIdentifier"
  org_id          = harness_platform_organization.this.identifier
  project_id      = harness_platform_project.this.identifier
  type            = "KubernetesDirect"
  deployment_type = "Kubernetes"
  yaml            = <<-EOT
infrastructureDefinition:
  name: gke-ecomm-dev
  identifier: gkeecommdev
  orgIdentifier: ${harness_platform_organization.this.identifier}
  projectIdentifier: ${harness_platform_project.this.identifier}
  environmentRef: ${harness_platform_environment.this.identifier}
  deploymentType: Kubernetes
  type: KubernetesDirect
  spec:
    connectorRef: account.${harness_platform_connector_kubernetes.dev.identifier}
    namespace: default
    releaseName: release-<+INFRA_KEY_SHORT_ID>
  allowSimultaneousDeployments: false
  EOT
}
