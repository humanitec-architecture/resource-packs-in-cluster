variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "name" {
  description = "Name of the deployment"
  type        = string

  # Deployment names shouldn't be > 47 https://pauldally.medium.com/why-you-try-to-keep-your-deployment-names-to-47-characters-or-less-1f93a848d34c
  # 47 - 6 (prefix) = 41
  default = <<EOT
mongo-{{ "$${context.res.id}" | replace "." "-" | substr 0 41 }}
EOT
}
