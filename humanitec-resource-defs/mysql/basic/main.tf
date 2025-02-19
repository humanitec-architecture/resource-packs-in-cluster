resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}mysql"
  name        = "${var.prefix}mysql"
  type        = "mysql"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode(yamldecode(file("${path.module}/definition-values.yaml")))
  }
}
