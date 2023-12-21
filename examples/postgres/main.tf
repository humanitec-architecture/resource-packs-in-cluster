# Postgres

locals {
  res_def_prefix = "dev-in-cluster-"
  postgres_class = "dev-in-cluster-postgres"
}

module "postgres_basic" {
  source = "../../humanitec-resource-defs/postgres/basic"

  prefix = local.res_def_prefix
}

resource "humanitec_resource_definition_criteria" "postgres_basic" {
  resource_definition_id = module.postgres_basic.id
  class                  = local.postgres_class
}
