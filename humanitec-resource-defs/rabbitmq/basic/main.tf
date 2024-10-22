resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}rabbitmq"
  name        = "${var.prefix}rabbitmq"
  type        = "amqp"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        cookie    = <<EOL
port: {{ .init.port }}
user: {{ .init.user }}
password: {{ .init.password }}
vhost: {{ .init.vhost }}
erlangcookie: {{ .init.erlangcookie }}
EOL
        init      = <<EOL
{{- if .cookie}}
port: {{ .cookie.port }}
user: {{ .cookie.user }}
password: {{ .cookie.password }}
vhost: {{ .cookie.vhost }}
erlangcookie: {{ .cookie.erlangcookie }}
{{- else }}
port: 5672
user: {{ randAlpha 8 | lower | quote }}
password: {{ randAlphaNum 16 | quote }}
vhost: {{ randAlpha 8 | lower | quote }}
erlangcookie: {{ randAlpha 20 }}
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
      serviceName: rabbitmq
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
              image: rabbitmq:3-management-alpine
              env:
                - name: RABBITMQ_ERLANG_COOKIE
                  valueFrom:
                    secretKeyRef:
                      name: {{ .init.name }}
                      key: RABBITMQ_ERLANG_COOKIE
                - name: RABBITMQ_DEFAULT_VHOST
                  value: {{ .init.vhost | quote }}
                - name: RABBITMQ_DEFAULT_USER
                  valueFrom:
                    secretKeyRef:
                      name: {{ .init.name }}
                      key: RABBITMQ_DEFAULT_USER
                - name: RABBITMQ_DEFAULT_PASS
                  valueFrom:
                    secretKeyRef:
                      name: {{ .init.name }}
                      key: RABBITMQ_DEFAULT_PASS
                - name: RABBITMQ_NODE_PORT
                  value: {{ .init.port | quote }}
              ports:
                - containerPort: {{ .init.port }}
                  protocol: TCP
                  name: amqp
                - name: http
                  protocol: TCP
                  containerPort: 15672
              volumeMounts:
                - name: {{ .init.name }}
                  mountPath: /var/lib/rabbitmq
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
      type: ClusterIP
      selector:
        app: {{ .init.name }}
      ports:
      - name: amqp
        port: {{ .init.port }}
        targetPort: amqp
      - name: http
        port: 15672
        targetPort: http
secret.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Secret
    metadata:
      name: {{ .init.name }}
    type: Opaque
    data:
      RABBITMQ_ERLANG_COOKIE: {{ .init.erlangcookie | b64enc }}
      RABBITMQ_DEFAULT_USER: {{ .init.user | b64enc }}
      RABBITMQ_DEFAULT_PASS: {{ .init.password | b64enc }}
EOL
        outputs   = <<EOL
host: {{ .init.name }}
port: {{ .init.port }}
vhost: {{ .init.vhost }}
EOL
        secrets   = <<EOL
username: {{ .init.user }}
password: {{ .init.password }}
EOL
      }
    })
  }
}
