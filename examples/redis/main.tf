resource "humanitec_application" "example" {
  id   = var.name
  name = var.name
}

# redis resource definition

module "redis_basic" {
  source = "../../humanitec-resource-defs/redis/basic"

  prefix = var.prefix
}

resource "humanitec_resource_definition_criteria" "redis_basic" {
  resource_definition_id = module.redis_basic.id
  app_id                 = humanitec_application.example.id
  class                  = "default"
  force_delete           = true
}
