resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}mysql"
  name        = "${var.prefix}mysql"
  type        = "mysql"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        cookie    = <<EOL
port: {{ .init.port }}
user: {{ .init.user }}
password: {{ .init.password }}
rootPassword: {{ .init.rootPassword }}
database: {{ .init.database }}
EOL
        init      = <<EOL
{{- if .cookie}}
port: {{ .cookie.port }}
user: {{ .cookie.user }}
password: {{ .cookie.password }}
rootPassword: {{ .cookie.rootPassword }}
database: {{ .cookie.database }}
{{- else }}
port: 3306
user: {{ randAlpha 8 | lower | quote }}
password: {{ randAlphaNum 16 | quote }}
rootPassword: {{ randAlphaNum 16 | quote }}
database: {{ randAlpha 8 | lower | quote }}
{{- end }}
name: ${var.name}
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
      serviceName: mysql
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
              image: mysql:8.0
              env:
                - name: MYSQL_ROOT_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: {{ .init.name }}
                      key: MYSQL_ROOT_PASSWORD
                - name: MYSQL_DATABASE
                  value: {{ .init.database | quote }}
                - name: MYSQL_USER
                  value: {{ .init.user | quote }}
                - name: MYSQL_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: {{ .init.name }}
                      key: MYSQL_PASSWORD
              ports:
                - containerPort: 3306
                  name: mysql
              volumeMounts:
                - name: {{ .init.name }}
                  mountPath: /var/lib/mysql
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
        targetPort: mysql
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
      MYSQL_ROOT_PASSWORD: {{ .init.rootPassword | b64enc }}
      MYSQL_PASSWORD: {{ .init.password | b64enc }}
EOL
        outputs   = <<EOL
host: {{ .init.name }}
port: {{ .init.port }}
name: {{ .init.database }}
EOL
        secrets   = <<EOL
username: {{ .init.user }}
password: {{ .init.password }}
EOL
      }
    })
  }
}
