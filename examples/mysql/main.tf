resource "humanitec_application" "example" {
  id   = var.name
  name = var.name
}

# mysql resource definition

module "mysql_basic" {
  source = "../../humanitec-resource-defs/mysql/basic"

  prefix = var.prefix
}

resource "humanitec_resource_definition_criteria" "mysql_basic" {
  resource_definition_id = module.mysql_basic.id
  app_id                 = humanitec_application.example.id
  class                  = "default"
  force_delete           = true
}
