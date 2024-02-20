variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "name" {
  description = "Name of the statefulset"
  type        = string

  # Pods names are limited to 63 characters (https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#dns-label-names)
  # 63 - 6 (prefix) - 2 (suffix) = 55
  default = <<EOT
mysql-{{ "$${context.res.id}" | replace "." "-" | substr 0 55 }}
EOT
}
