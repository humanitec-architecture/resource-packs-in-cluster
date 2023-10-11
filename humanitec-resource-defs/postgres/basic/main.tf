resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}postgres"
  name        = "${var.prefix}postgres"
  type        = "postgres"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        cookie    = <<EOL
port: {{ .init.port }}
user: {{ .init.user }}
password: {{ .init.password }}
database: {{ .init.database }}
EOL
        init      = <<EOL
{{- if .cookie}}
port: {{ .cookie.port }}
user: {{ .cookie.user }}
password: {{ .cookie.password }}
database: {{ .cookie.database }}
{{- else }}
port: 5432
user: {{ randAlpha 8 | lower | quote }}
password: {{ randAlphaNum 16 | quote }}
database: {{ randAlpha 8 | lower | quote }}
{{- end }}
name: postgres-{{ .id }}
EOL
        manifests = <<EOL
statefulset.yaml:
  location: namespace
  data:
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: {{ .init.name }}
    spec:
      serviceName: postgres
      replicas: 1
      selector:
        matchLabels:
          app: {{ .init.name }}
      template:
        metadata:
          labels:
            app: {{ .init.name }}
        spec:
          containers:
            - name: {{ .init.name }}
              image: postgres:15
              env:
                - name: POSTGRES_USER
                  value: {{ .init.user | quote }}
                - name: POSTGRES_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: {{ .init.name }}
                      key: POSTGRES_PASSWORD
                - name: PGDATA
                  value: /var/lib/postgresql/data/pgdata
                - name: PGPORT
                  value: {{ .init.port | quote }}
              ports:
                - containerPort: {{ .init.port }}
                  name: postgres
              volumeMounts:
                - name: {{ .init.name }}
                  mountPath: /var/lib/postgresql/data
      volumeClaimTemplates:
        - metadata:
            name: {{ .init.name }}
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 10Gi
service.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Service
    metadata:
      name: {{ .init.name }}
    spec:
      ports:
      - port: {{ .init.port }}
      selector:
        app: {{ .init.name }}
      clusterIP: None
secret.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Secret
    metadata:
      name: {{ .init.name }}
    type: Opaque
    data:
      POSTGRES_PASSWORD: {{ .init.password | b64enc }}
EOL
        outputs   = <<EOL
host: {{ .init.name }}
port: {{ .init.port }}
name: {{ .init.database }}
EOL
      }
    })
    secrets_string = jsonencode({
      templates = {
        outputs = <<EOL
username: {{ .init.user }}
password: {{ .init.password }}
EOL
      }
    })
  }
}
