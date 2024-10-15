resource "humanitec_resource_definition" "main" {
  id          = "${var.prefix}mongodb"
  name        = "${var.prefix}mongodb"
  type        = "mongodb"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        cookie    = <<EOL
rootUsername: {{ .init.rootUsername }}
name:         {{ .init.name }}
rootPassword: {{ .init.rootPassword }}
port:         {{ .init.port }}
EOL
        init      = <<EOL
{{- if .cookie}}
rootUsername: {{ .cookie.rootUsername }}
name:         {{ .cookie.name }}
rootPassword: {{ .cookie.rootPassword }}
port:         {{ .cookie.port }}
{{- else }}
rootUsername: {{ randAlpha 8 | lower | quote }}
rootPassword: {{ randAlphaNum 16 | quote }}
name:         db_{{ randAlpha 10}}
port:         27017
{{- end }}
id: mongodb-{{ .id }}
EOL
        manifests = <<EOL
deployment.yaml:
  location: namespace
  data:
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: {{ .init.id }}
    spec:
      selector:
        matchLabels:
          app: {{ .init.id }}
      template:
        metadata:
          labels:
            app: {{ .init.id }}
        spec:
          automountServiceAccountToken: false
          containers:
          - name: mongodb
            image: mongo:8
            ports:
            - containerPort: {{ .init.port }}
            env:
            - name: MONGO_INITDB_ROOT_USERNAME
              value: {{ .init.rootUsername }}
            - name: MONGO_INITDB_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ .init.id }}
                  key: MONGO_INITDB_ROOT_PASSWORD
            securityContext:
                runAsUser: 1001
                runAsGroup: 1001
                allowPrivilegeEscalation: false
                privileged: false
                readOnlyRootFilesystem: true
                capabilities:
                  drop:
                    - ALL
            volumeMounts:
              - name: data
                mountPath: /data/db
              - name: tmp
                mountPath: /tmp
          securityContext:
            runAsNonRoot: true
            fsGroup: 1001
            seccompProfile:
              type: RuntimeDefault
          volumes:
          - name: data
            persistentVolumeClaim:
              claimName: pvc-{{ .init.id }}
          - name: tmp
                emptyDir: {}
pvc.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: pvc-{{ .init.id }}
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1G
service.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Service
    metadata:
      name: {{ .init.id }}
    spec:
      type: ClusterIP
      selector:
        app: {{ .init.id }}
      ports:
      - name: tcp-mongodb
        port: {{ .init.port }}
        targetPort: {{ .init.port }}
secret.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Secret
    metadata:
      name: {{ .init.id }}
    type: Opaque
    data:
      MONGO_INITDB_ROOT_PASSWORD: {{ .init.rootPassword | b64enc }}
EOL
        secrets   = <<EOL
connection: mongodb://{{ .init.rootUsername }}:{{ .init.rootPassword }}@{{ .init.id }}:{{ .init.port }}/
EOL
      }
    })
  }
}
