resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}redis"
  name        = "${var.prefix}redis"
  type        = "redis"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode(yamldecode(file("${path.module}/definition-values.yaml")))
  }
}
