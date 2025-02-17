resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}rabbitmq"
  name        = "${var.prefix}rabbitmq"
  type        = "amqp"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode(yamldecode(file("${path.module}/definition-values.yaml")))
  }
}
