# resource "harness_platform_organization" "this" {
#   identifier  = "Cristian_Demo"
#   name        = "Cristian Demo"
#   description = "Organization provisioned by terraform"
#   tags        = ["owner:cristian.ramirez@harness.io"]
# }

resource "harness_platform_project" "this" {
  identifier = replace(var.service_name, "-", "_")
  name       = var.service_name
  org_id     = var.org_id
  color      = "#0063F7"
  tags       = ["owner:cristian.ramirez@harness.io"]
}
