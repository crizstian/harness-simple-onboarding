resource "harness_platform_organization" "this" {
  identifier  = "Cristian_Demo"
  name        = "Cristian Demo"
  description = "Organization provisioned by terraform"
  tags        = ["owner:cristian.ramirez@harness.io"]
}

resource "harness_platform_project" "this" {
  identifier = "Project_Demo"
  name       = "Project Demo"
  org_id     = harness_platform_organization.this.identifier
  color      = "#0063F7"
  tags       = ["owner:cristian.ramirez@harness.io"]
}
