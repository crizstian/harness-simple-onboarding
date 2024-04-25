variable "service_name" {}
variable "org_id" {}
# variable "project_id" {}

resource "harness_platform_service" "this" {
  identifier  = replace(var.service_name, "-", "_")
  name        = var.service_name
  description = "connector provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
  org_id      = var.org_id
  project_id  = harness_platform_project.this.identifier

  yaml = <<-EOT
service:
  name: ${var.service_name}
  identifier: ${replace(var.service_name, "-", "_")}
  orgIdentifier: ${var.org_id}
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
                  connectorRef: account.Cristian_V2_Org
                  gitFetchType: Branch
                  paths:
                    - deploy
                  repoName: ${var.service_name}
                  branch: main
              valuesPaths: <+input>
              skipResourceVersioning: false
              enableDeclarativeRollback: false
      artifacts:
        primary:
          primaryArtifactRef: <+input>
          sources:
            - spec:
                connectorRef: account.cristian_docker
                imagePath: crizstian/payment-service-workshop
                tag: <+input>
                digest: ""
              identifier: Docker
              type: DockerRegistry


    EOT
}
