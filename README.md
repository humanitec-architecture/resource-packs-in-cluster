# In-cluster resource pack

---

:construction: __This pack is experimental and currently not recommended for production usage.__ :construction:

---

A collection of in-cluster resources ready to be used with [Humanitec](https://humanitec.com/).

The following resources are included:

* [mysql/basic](./humanitec-resource-defs/mysql/basic): A basic MySQL.
* [postgres/basic](./humanitec-resource-defs/postgres/basic): A basic Postgres.
* [redis/basic](./humanitec-resource-defs/redis/basic): A basic Redis.

The `humanitec-resource-defs` directory includes the respective resource definitions.

Checkout the following examples to use them in Humanitec:
- `postgres`: [`examples/postgres/main.tf`](examples/postgres/main.tf)
- `mysql`: [`examples/mysql/main.tf`](examples/mysql/main.tf)
- `redis`: [`examples/redis/main.tf`](examples/redis/main.tf)