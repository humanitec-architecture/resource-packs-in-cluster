variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "name" {
  description = "Name of the statefulset"
  type        = string

  # StatefulSets names are limited to 52 chars https://github.com/kubernetes/kubernetes/issues/64023
  # 52 - 6 (prefix) = 46
  default = <<EOT
mysql-{{ "$${context.res.id}" | replace "." "-" | substr 0 46 }}
EOT
}
