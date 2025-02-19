# Example: mysql resource using a Kubernetes StatefulSet

This example configures a [mysql](https://developer.humanitec.com/platform-orchestrator/reference/resource-types/#mysql) Resource Definition using Kubernetes `StatefulSet`.

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
| mysql\_basic | ../../humanitec-resource-defs/mysql/basic | n/a |

## Resources

| Name | Type |
|------|------|
| [humanitec_resource_definition_criteria.mysql_basic](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | Prefix for the resource definition in Humanitec | `string` | `"hum-rp-mysql-ex-"` | no |
<!-- END_TF_DOCS -->

## Deploy and use this example

To deploy this resource definition, run these commands below:
```bash
git clone https://github.com/humanitec-architecture/resource-packs-in-cluster

cd examples/mysql/

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
    image: nginx:latest # this container image is just used as an example, it's not talking to mysql.
    variables:
      MYSQL_CONNECTION_STRING: "Server=${resources.my-mysql.host};Port=${resources.my-mysql.port};Database=${resources.my-mysql.name};Uid=${resources.my-mysql.username};Pwd=${resources.my-mysql.password};"
resources:
  my-mysql:
    type: mysql
```

This Score file when deployed to Humanitec will provision the `mysql` database and inject the outputs in the associated environment variable.

Here is how to deploy this Score file, for example to the `mysql-example` Application and `development` Environment:
```bash
humctl create app mysql-example

humctl score deploy \
    -f score.yaml \
    --app mysql-example \
    --env development
```