# In-cluster resource pack

---

:construction: __This pack is experimental and currently not recommended for production usage.__ :construction:

---

## Overview

A collection of in-cluster resources ready to be used with [Humanitec](https://humanitec.com/).

The Resource Pack uses [Terraform](https://terraform.io) and the [Humanitec Terraform Provider](https://registry.terraform.io/providers/humanitec/humanitec) to create Resource Definitions in your Humanitec Organization.

## Usage

You may either install a Resource Definition from the Pack as-is or adopt the Terraform source code into your own Terraform estate.

The following resources are included:

- `mongodb/basic`: a basic MongoDB ([Installation instructions](./examples/mongodb/README.md#deploy-and-use-this-example) / [Terraform source](./humanitec-resource-defs/mongodb/basic))
- `mysql/basic`: a basic MySQL ([Installation instructions](./examples/mysql/README.md#deploy-and-use-this-example) / [Terraform source](./humanitec-resource-defs/mysql/basic))
- `postgres/basic`: a basic Postgres ([Installation instructions](./examples/postgres/README.md#deploy-and-use-this-example) / [Terraform source](./humanitec-resource-defs/postgres/basic))
- `rabbitmq/basic`: a basic RabbitMQ ([Installation instructions](./examples/rabbitmq/README.md#deploy-and-use-this-example) / [Terraform source](./humanitec-resource-defs/rabbitmq/basic))
- `redis/basic`: a basic Redis ([Installation instructions](./examples/redis/README.md#deploy-and-use-this-example) / [Terraform source](./humanitec-resource-defs/redis/basic))

## Repository structure

The `examples` directory includes the respective installation instructions.

The `humanitec-resource-defs` directory includes the Terraform sources for the respective Resource Definitions.