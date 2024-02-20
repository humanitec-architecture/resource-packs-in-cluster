resource "humanitec_application" "example" {
  id   = var.name
  name = var.name
}

# postgres resource definition

module "postgres_basic" {
  source = "../../humanitec-resource-defs/postgres/basic"

  prefix = var.prefix
}

resource "humanitec_resource_definition_criteria" "postgres_basic" {
  resource_definition_id = module.postgres_basic.id
  app_id                 = humanitec_application.example.id
  class                  = "default"
  force_delete           = true
}
