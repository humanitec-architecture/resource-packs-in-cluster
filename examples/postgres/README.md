# Example: postgres resource using a Kubernetes StatefulSet

This example configures a [postgres](https://developer.humanitec.com/platform-orchestrator/reference/resource-types/#postgres) Resource Definition using Kubernetes `StatefulSet`.

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
| [humanitec_resource_definition_criteria.postgres_basic](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | Prefix for the resource definition in Humanitec | `string` | `"hum-rp-postgres-ex-"` | no |
<!-- END_TF_DOCS -->

## Deploy and use this example

To deploy this resource definition, run these commands below:
```bash
git clone https://github.com/humanitec-architecture/resource-packs-in-cluster

cd examples/postgres/

humctl login
humctl config set org YOUR-ORG

terraform init
terraform plan
terraform apply
```

The created Resource Definition can be used in your Score file like illustrated below:
```yaml
apiVersion: score.dev/v1b1
metadata:
  name: my-workload
containers:
  my-container:
    image: nginx:latest # this container image is just used as an example, it's not talking to postgres.
    variables:
      POSTGRES_CONNECTION_STRING: "postgresql://${resources.my-postgres.username}${resources.my-postgres.password}@${resources.my-postgres.host}:${resources.my-postgres.port}/${resources.my-postgres.name}"
resources:
  my-postgres:
    type: postgres
```

This Score file when deployed to Humanitec will provision the `postgres` database and inject the outputs in the associated environment variable.

Here is how to deploy this Score file, for example to the `postgres-example` Application and `development` Environment:
```bash
humctl create app postgres-example

humctl score deploy \
    -f score.yaml \
    --app postgres-example \
    --env development
```