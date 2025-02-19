resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}mongodb"
  name        = "${var.prefix}mongodb"
  type        = "mongodb"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode(yamldecode(file("${path.module}/definition-values.yaml")))
  }
}
