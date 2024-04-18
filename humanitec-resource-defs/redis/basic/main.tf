resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}redis"
  name        = "${var.prefix}redis"
  type        = "redis"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        cookie    = <<EOL
port: {{ .init.port }}
EOL
        init      = <<EOL
{{- if .cookie}}
port: {{ .cookie.port }}
{{- else }}
port: 6379
{{- end }}
name: ${var.name}
EOL
        manifests = <<EOL
deployment.yaml:
  location: namespace
  data:
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: {{ .init.name }}
    spec:
      serviceName: redis
      replicas: 1
      selector:
        matchLabels:
          app: {{ .init.name }}
      template:
        metadata:
          labels:
            app: {{ .init.name }}
        spec:
          securityContext:
            fsGroup: 1000
            runAsGroup: 1000
            runAsNonRoot: true
            runAsUser: 1000
            seccompProfile:
              type: RuntimeDefault
          containers:
          - name: {{ .init.name }}
            securityContext:
              allowPrivilegeEscalation: false
              capabilities:
                drop:
                  - ALL
              privileged: false
              readOnlyRootFilesystem: true
            image: redis:7-alpine
            ports:
            - name: tcp-redis
              containerPort: 6379
            volumeMounts:
            - mountPath: /data
              name: redis-data
          volumes:
          - name: redis-data
            emptyDir: {}
service.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Service
    metadata:
      name: {{ .init.name }}
    spec:
      type: ClusterIP
      selector:
        app: {{ .init.name }}
      ports:
      - name: tcp-redis
        port: {{ .init.port }}
        targetPort: tcp-redis
EOL
        outputs   = <<EOL
host: {{ .init.name }}
port: {{ .init.port }}
EOL
        secrets   = <<EOL
username: ""
password: ""
EOL
      }
    })
  }
}
