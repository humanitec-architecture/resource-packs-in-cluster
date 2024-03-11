# Example: postgres resource using a Kubernetes StatefulSet

This example configures a [postgres](https://developer.humanitec.com/platform-orchestrator/reference/resource-types/#postgres) Resource Definition using Kubernetes StatefulSet.

The created Resource Definition can be used in your Score file using:

```yaml
resources:
  ...
  db:
    type: postgres
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
| postgres\_basic | ../../humanitec-resource-defs/postgres/basic | n/a |

## Resources

| Name | Type |
|------|------|
| [humanitec_application.example](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/application) | resource |
| [humanitec_resource_definition_criteria.postgres_basic](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the example application | `string` | `"hum-rp-postgres-example"` | no |
| prefix | Prefix of the created resources | `string` | `"hum-rp-postgres-ex-"` | no |
<!-- END_TF_DOCS -->
