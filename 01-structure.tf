resource "harness_platform_organization" "this" {
  identifier  = replace(var.organization, "-","")
  name        = var.organization
  description = "Organization provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
}

resource "harness_platform_project" "this" {
  identifier  = replace(var.project, "-","")
  name        = var.project
  org_id     = harness_platform_organization.this.identifier
  color      = "#0063F7"
  tags       = ["owner:cristian.ramirez@harness.io"]
}
