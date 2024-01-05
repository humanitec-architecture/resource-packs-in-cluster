# Redis

locals {
  res_def_prefix = "dev-in-cluster-"
  redis_class    = "dev-in-cluster-redis"
}

module "redis_basic" {
  source = "../../humanitec-resource-defs/redis/basic"
  prefix = local.res_def_prefix
}

resource "humanitec_resource_definition_criteria" "redis_basic" {
  resource_definition_id = module.redis_basic.id
  class                  = local.redis_class
}
