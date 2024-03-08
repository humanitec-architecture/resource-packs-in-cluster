# Example: redis resource using a Kubernetes Deployment

This example configures a [redis](https://developer.humanitec.com/platform-orchestrator/reference/resource-types/#redis) Resource Definition using Kubernetes Deployment.

The created Resource Definition can be used in your Score file using:

```yaml
resources:
  ...
  redis:
    type: redis
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| humanitec | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| humanitec | ~> 1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| redis\_basic | ../../humanitec-resource-defs/redis/basic | n/a |

## Resources

| Name | Type |
|------|------|
| [humanitec_application.example](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/application) | resource |
| [humanitec_resource_definition_criteria.redis_basic](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the example application | `string` | `"hum-rp-redis-example"` | no |
| prefix | Prefix of the created resources | `string` | `"hum-rp-redis-ex-"` | no |
<!-- END_TF_DOCS -->
