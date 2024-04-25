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
