# Example: redis resource using a Kubernetes Deployment

This example configures a [redis](https://developer.humanitec.com/platform-orchestrator/reference/resource-types/#redis) Resource Definition using Kubernetes `Deployment`.

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


## Deploy and use this example

To deploy this resource definition, run these commands below:
```bash
git clone https://github.com/humanitec-architecture/resource-packs-in-cluster

cd examples/redis/

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
    image: nginx:latest # this container image is just used as an example, it's not talking to redis.
    variables:
      REDIS_CONNECTION_STRING: "${resources.my-redis.host}:${resources.my-redis.port},user=${resources.my-redis.username},password=${resources.my-redis.password}"
resources:
  my-redis:
    type: redis
```

This Score file when deployed to Humanitec will provision the `redis` database and inject the outputs in the associated environment variable.

Here is how to deploy this Score file, for example to the `hum-rp-redis-example` Application and `development` Environment:
```bash
humctl score deploy \
    -f score.yaml \
    --app hum-rp-redis-example \
    --env development
```