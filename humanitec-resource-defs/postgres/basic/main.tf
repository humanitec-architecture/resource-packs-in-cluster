resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}postgres"
  name        = "${var.prefix}postgres"
  type        = "postgres"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode(yamldecode(file("${path.module}/definition-values.yaml")))
  }
}
