resource "humanitec_application" "example" {
  id   = var.name
  name = var.name
}

# mysql resource definition

module "mongodb_basic" {
  source = "../../humanitec-resource-defs/mongodb/basic"

  prefix = var.prefix
}

resource "humanitec_resource_definition_criteria" "mongodb_basic" {
  resource_definition_id = module.mongodb_basic.id
  app_id                 = humanitec_application.example.id
  class                  = "default"
  force_delete           = true
}
