module "rabbitmq_basic" {
  source = "../../humanitec-resource-defs/rabbitmq/basic"

  prefix = var.prefix
}

resource "humanitec_resource_definition_criteria" "rabbitmq_basic" {
  resource_definition_id = module.rabbitmq_basic.id
  class                  = "default"
  force_delete           = true
}
