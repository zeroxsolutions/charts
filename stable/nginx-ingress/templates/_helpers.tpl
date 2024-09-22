{{/*
Create a default fully qualified controller name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nginx-ingress.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified controller service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nginx-ingress.service.name" -}}
{{- default (include "nginx-ingress.fullname" .) .Values.serviceNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Pod labels
*/}}
{{- define "nginx-ingress.podLabels" -}}
{{- include "common.selectorLabels" . }}
{{- if .Values.nginxServiceMesh.enable }}
nsm.nginx.com/enable-ingress: "true"
nsm.nginx.com/enable-egress: "{{ .Values.nginxServiceMesh.enableEgress }}"
nsm.nginx.com/{{ .Values.kind }}: {{ include "nginx-ingress.fullname" . }}
{{- end }}
{{- if and .Values.nginxAgent.enable (eq (.Values.nginxAgent.customConfigMap | default "") "") }}
agent-configuration-revision-hash: {{ include "nginx-ingress.agentConfiguration" . | sha1sum | trunc 8 | quote }}
{{- end }}
{{- if .Values.pod.extraLabels }}
{{ toYaml .Values.pod.extraLabels }}
{{- end }}
{{- end }}

{{/*
Expand the name of the configmap.
*/}}
{{- define "nginx-ingress.configName" -}}
{{- if .Values.customConfigMap -}}
{{ .Values.customConfigMap }}
{{- else -}}
{{- default (include "common.names.fullname" .) .Values.config.name -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the configmap used for NGINX Agent.
*/}}
{{- define "nginx-ingress.agentConfigName" -}}
{{- if ne (.Values.nginxAgent.customConfigMap | default "") "" -}}
{{ .Values.nginxAgent.customConfigMap }}
{{- else -}}
{{- printf "%s-agent-config"  (include "common.names.fullname" . | trunc 49 | trimSuffix "-") -}}
{{- end -}}
{{- end -}}

{{/*
Expand leader election lock name.
*/}}
{{- define "nginx-ingress.leaderElectionName" -}}
{{- if .Values.reportIngressStatus.leaderElectionLockName -}}
{{ .Values.reportIngressStatus.leaderElectionLockName }}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "leader-election" -}}
{{- end -}}
{{- end -}}

{{/*
Expand default TLS name.
*/}}
{{- define "nginx-ingress.defaultTLSName" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "default-server-tls" -}}
{{- end -}}

{{/*
Expand wildcard TLS name.
*/}}
{{- define "nginx-ingress.wildcardTLSName" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "wildcard-tls" -}}
{{- end -}}

{{- define "nginx-ingress.tag" -}}
{{- default .Chart.AppVersion .Values.image.tag -}}
{{- end -}}

{{/*
Expand image name.
*/}}
{{- define "nginx-ingress.image" -}}
{{ include "nginx-ingress.image-digest-or-tag" (dict "image" .Values.image "default" .Chart.AppVersion ) }}
{{- end -}}

{{- define "nap-enforcer.image" -}}
{{ include "nginx-ingress.image-digest-or-tag" (dict "image" .Values.appprotect.enforcer.image "default" .Chart.AppVersion ) }}
{{- end -}}

{{- define "nap-config-manager.image" -}}
{{ include "nginx-ingress.image-digest-or-tag" (dict "image" .Values.appprotect.configManager.image "default" .Chart.AppVersion ) }}
{{- end -}}

{{/*
Accepts an image struct like .Values.image along with a default value to use
if the digest or tag is not set. Can be called like:
include "nginx-ingress.image-digest-or-tag" (dict "image" .Values.image "default" .Chart.AppVersion
*/}}
{{- define "nginx-ingress.image-digest-or-tag" -}}
{{- if .image.digest -}}
{{- printf "%s@%s" .image.repository .image.digest -}}
{{- else -}}
{{- printf "%s:%s" .image.repository (default .default .image.tag) -}}
{{- end -}}
{{- end -}}

{{- define "nginx-ingress.prometheus.serviceName" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "prometheus-service"  -}}
{{- end -}}

{{/*
return if readOnlyRootFilesystem is enabled or not.
*/}}
{{- define "nginx-ingress.readOnlyRootFilesystem" -}}
{{- if or .Values.readOnlyRootFilesystem (and .Values.securityContext .Values.securityContext.readOnlyRootFilesystem) -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}

{{/*
Build the args for the service binary.
*/}}
{{- define "nginx-ingress.args" -}}
{{- if and .Values.debug .Values.debug.enable }}
- --listen=:2345
- --headless=true
- --log=true
- --log-output=debugger,debuglineerr,gdbwire,lldbout,rpc,dap,fncall,minidump,stack
- --accept-multiclient
- --api-version=2
- exec
- ./nginx-ingress
{{- if .Values.debug.continue }}
- --continue
{{- end }}
- --
{{- end -}}
- -nginx-plus={{ .Values.nginxplus }}
- -nginx-reload-timeout={{ .Values.nginxReloadTimeout }}
- -enable-app-protect={{ .Values.appprotect.enable }}
{{- if and .Values.appprotect.enable .Values.appprotect.logLevel }}
- -app-protect-log-level={{ .Values.appprotect.logLevel }}
{{ end }}
{{- if and .Values.appprotect.enable .Values.appprotect.v5 }}
- -app-protect-enforcer-address="{{ .Values.appprotect.enforcer.host | default "127.0.0.1" }}:{{ .Values.appprotect.enforcer.port | default 50000 }}"
{{- end }}
- -enable-app-protect-dos={{ .Values.appprotectdos.enable }}
{{- if .Values.appprotectdos.enable }}
- -app-protect-dos-debug={{ .Values.appprotectdos.debug }}
- -app-protect-dos-max-daemons={{ .Values.appprotectdos.maxDaemons }}
- -app-protect-dos-max-workers={{ .Values.appprotectdos.maxWorkers }}
- -app-protect-dos-memory={{ .Values.appprotectdos.memory }}
{{ end }}
- -nginx-configmaps=$(POD_NAMESPACE)/{{ include "nginx-ingress.configName" . }}
{{- if .Values.defaultTLS.secret }}
- -default-server-tls-secret={{ .Values.defaultTLS.secret }}
{{ else if and (.Values.defaultTLS.cert) (.Values.defaultTLS.key) }}
- -default-server-tls-secret=$(POD_NAMESPACE)/{{ include "nginx-ingress.defaultTLSName" . }}
{{- end }}
- -ingress-class={{ .Values.ingressClass.name }}
{{- if .Values.watchNamespace }}
- -watch-namespace={{ .Values.watchNamespace }}
{{- end }}
{{- if .Values.watchNamespaceLabel }}
- -watch-namespace-label={{ .Values.watchNamespaceLabel }}
{{- end }}
{{- if .Values.watchSecretNamespace }}
- -watch-secret-namespace={{ .Values.watchSecretNamespace }}
{{- end }}
- -health-status={{ .Values.healthStatus }}
- -health-status-uri={{ .Values.healthStatusURI }}
- -nginx-debug={{ .Values.nginxDebug }}
- -v={{ .Values.logLevel }}
- -nginx-status={{ .Values.nginxStatus.enable }}
{{- if .Values.nginxStatus.enable }}
- -nginx-status-port={{ .Values.nginxStatus.port }}
- -nginx-status-allow-cidrs={{ .Values.nginxStatus.allowCidrs }}
{{- end }}
{{- if .Values.reportIngressStatus.enable }}
- -report-ingress-status
{{- if .Values.reportIngressStatus.ingressLink }}
- -ingresslink={{ .Values.reportIngressStatus.ingressLink }}
{{- else if .Values.reportIngressStatus.externalService }}
- -external-service={{ .Values.reportIngressStatus.externalService }}
{{- else if and (.Values.service.create) (eq .Values.service.type "LoadBalancer") }}
- -external-service={{ include "nginx-ingress.service.name" . }}
{{- end }}
{{- end }}
- -enable-leader-election={{ .Values.reportIngressStatus.enableLeaderElection }}
{{- if .Values.reportIngressStatus.enableLeaderElection }}
- -leader-election-lock-name={{ include "nginx-ingress.leaderElectionName" . }}
{{- end }}
{{- if .Values.wildcardTLS.secret }}
- -wildcard-tls-secret={{ .Values.wildcardTLS.secret }}
{{- else if and .Values.wildcardTLS.cert .Values.wildcardTLS.key }}
- -wildcard-tls-secret=$(POD_NAMESPACE)/{{ include "nginx-ingress.wildcardTLSName" . }}
{{- end }}
- -enable-prometheus-metrics={{ .Values.prometheus.create }}
- -prometheus-metrics-listen-port={{ .Values.prometheus.port }}
- -prometheus-tls-secret={{ .Values.prometheus.secret }}
- -enable-service-insight={{ .Values.serviceInsight.create }}
- -service-insight-listen-port={{ .Values.serviceInsight.port }}
- -service-insight-tls-secret={{ .Values.serviceInsight.secret }}
- -enable-custom-resources={{ .Values.enableCustomResources }}
- -enable-snippets={{ .Values.enableSnippets }}
- -disable-ipv6={{ .Values.disableIPV6 }}
{{- if .Values.enableCustomResources }}
- -enable-tls-passthrough={{ .Values.enableTLSPassthrough }}
{{- if .Values.enableTLSPassthrough }}
- -tls-passthrough-port={{ .Values.tlsPassthroughPort }}
{{- end }}
- -enable-cert-manager={{ .Values.enableCertManager }}
- -enable-oidc={{ .Values.enableOIDC }}
- -enable-external-dns={{ .Values.enableExternalDNS }}
- -default-http-listener-port={{ .Values.defaultHTTPListenerPort}}
- -default-https-listener-port={{ .Values.defaultHTTPSListenerPort}}
{{- if .Values.globalConfiguration.create }}
- -global-configuration=$(POD_NAMESPACE)/{{ include "nginx-ingress.fullname" . }}
{{- end }}
{{- end }}
- -ready-status={{ .Values.readyStatus.enable }}
- -ready-status-port={{ .Values.readyStatus.port }}
- -enable-latency-metrics={{ .Values.enableLatencyMetrics }}
- -ssl-dynamic-reload={{ .Values.enableSSLDynamicReload }}
- -enable-telemetry-reporting={{ .Values.telemetryReporting.enable}}
- -weight-changes-dynamic-reload={{ .Values.enableWeightChangesDynamicReload}}
{{- if .Values.nginxAgent.enable }}
- -agent=true
- -agent-instance-group={{ default (include "nginx-ingress.fullname" .) .Values.nginxAgent.instanceGroup }}
{{- end }}
{{- end -}}

{{/*
Volumes for 
*/}}
{{- define "nginx-ingress.volumes" -}}
{{- $volumesSet := "false" }}
volumes:
{{- if eq (include "nginx-ingress.volumeEntries" .) "" -}}
{{ toYaml list | printf " %s" }}
{{- else }}
{{ include "nginx-ingress.volumeEntries" . }}
{{- end -}}
{{- end -}}

{{/*
List of volumes for 
*/}}
{{- define "nginx-ingress.volumeEntries" -}}
{{- if eq (include "nginx-ingress.readOnlyRootFilesystem" .) "true" }}
- name: nginx-etc
  emptyDir: {}
- name: nginx-cache
  emptyDir: {}
- name: nginx-lib
  emptyDir: {}
- name: nginx-log
  emptyDir: {}
{{- end }}
{{- if .Values.appprotect.v5 }}
{{- toYaml .Values.appprotect.volumes }}
{{- end }}
{{- if .Values.volumes }}
{{ toYaml .Values.volumes }}
{{- end }}
{{- if .Values.nginxAgent.enable }}
- name: agent-conf
  configMap:
    name: {{ include "nginx-ingress.agentConfigName" . }}
- name: agent-dynamic
  emptyDir: {}
{{- if and .Values.nginxAgent.instanceManager.tls (or (ne (.Values.nginxAgent.instanceManager.tls.secret | default "") "") (ne (.Values.nginxAgent.instanceManager.tls.caSecret | default "") "")) }}
- name: nginx-agent-tls
  projected:
    sources:
{{- if ne .Values.nginxAgent.instanceManager.tls.secret "" }}
      - secret:
          name: {{ .Values.nginxAgent.instanceManager.tls.secret }}
{{- end }}
{{- if ne .Values.nginxAgent.instanceManager.tls.caSecret "" }}
      - secret:
          name: {{ .Values.nginxAgent.instanceManager.tls.caSecret }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Volume mounts for 
*/}}
{{- define "nginx-ingress.volumeMounts" -}}
{{- $volumesSet := "false" }}
volumeMounts:
{{- if eq (include "nginx-ingress.volumeMountEntries" .) "" -}}
{{ toYaml list | printf " %s" }}
{{- else }}
{{ include "nginx-ingress.volumeMountEntries" . }}
{{- end -}}
{{- end -}}

{{- define "nginx-ingress.volumeMountEntries" -}}
{{- if eq (include "nginx-ingress.readOnlyRootFilesystem" .) "true" }}
- mountPath: /etc/nginx
  name: nginx-etc
- mountPath: /var/cache/nginx
  name: nginx-cache
- mountPath: /var/lib/nginx
  name: nginx-lib
- mountPath: /var/log/nginx
  name: nginx-log
{{- end }}
{{- if .Values.appprotect.v5 }}
- name: app-protect-bd-config
  mountPath: /opt/app_protect/bd_config
- name: app-protect-config
  mountPath: /opt/app_protect/config
  # app-protect-bundles is mounted so that Ingress Controller
  # can verify that referenced bundles are present
- name: app-protect-bundles
  mountPath: /etc/app_protect/bundles
{{- end }}
{{- if .Values.volumeMounts }}
{{ toYaml .Values.volumeMounts }}
{{- end }}
{{- if .Values.nginxAgent.enable }}
- name: agent-conf
  mountPath: /etc/nginx-agent/nginx-agent.conf
  subPath: nginx-agent.conf
- name: agent-dynamic
  mountPath: /var/lib/nginx-agent
{{- if and .Values.nginxAgent.instanceManager.tls (or (ne (.Values.nginxAgent.instanceManager.tls.secret | default "") "") (ne (.Values.nginxAgent.instanceManager.tls.caSecret | default "") "")) }}
- name: nginx-agent-tls
  mountPath: /etc/ssl/nms
  readOnly: true
{{- end }}
{{- end -}}
{{- end -}}

{{- define "nginx-ingress.appprotect.v5" -}}
{{- if .Values.appprotect.v5}}
- name: waf-enforcer
  image: {{ include "nap-enforcer.image" . }}
  imagePullPolicy: "{{ .Values.appprotect.enforcer.image.pullPolicy }}"
{{- if .Values.appprotect.enforcer.securityContext }}
  securityContext:
{{ toYaml .Values.appprotect.enforcer.securityContext | nindent 6 }}
{{- end }}
  env:
    - name: ENFORCER_PORT
      value: "{{ .Values.appprotect.enforcer.port | default 50000 }}"
  volumeMounts:
    - name: app-protect-bd-config
      mountPath: /opt/app_protect/bd_config
- name: waf-config-mgr
  image: {{ include "nap-config-manager.image" . }}
  imagePullPolicy: "{{ .Values.appprotect.configManager.image.pullPolicy }}"
{{- if .Values.appprotect.configManager.securityContext }}
  securityContext:
{{ toYaml .Values.appprotect.configManager.securityContext | nindent 6 }}
{{- end }}
  volumeMounts:
    - name: app-protect-bd-config
      mountPath: /opt/app_protect/bd_config
    - name: app-protect-config
      mountPath: /opt/app_protect/config
    - name: app-protect-bundles
      mountPath: /etc/app_protect/bundles
{{- end}}
{{- end -}}

{{- define "nginx-ingress.agentConfiguration" -}}
log:
  level: {{ .Values.nginxAgent.logLevel }}
  path: ""
server:
  host: {{ required ".Values.nginxAgent.instanceManager.host is required when setting .Values.nginxAgent.enable to true" .Values.nginxAgent.instanceManager.host }}
  grpcPort: {{ .Values.nginxAgent.instanceManager.grpcPort }}
{{- if ne (.Values.nginxAgent.instanceManager.sni | default "") ""  }}
  metrics: {{ .Values.nginxAgent.instanceManager.sni }}
  command: {{ .Values.nginxAgent.instanceManager.sni }}
{{- end }}
{{- if .Values.nginxAgent.instanceManager.tls  }}
tls:
  enable: {{ .Values.nginxAgent.instanceManager.tls.enable | default true }}
  skip_verify: {{ .Values.nginxAgent.instanceManager.tls.skipVerify | default false }}
  {{- if ne .Values.nginxAgent.instanceManager.tls.caSecret "" }}
  ca: "/etc/ssl/nms/ca.crt"
  {{- end }}
  {{- if ne .Values.nginxAgent.instanceManager.tls.secret "" }}
  cert: "/etc/ssl/nms/tls.crt"
  key: "/etc/ssl/nms/tls.key"
  {{- end }}
{{- end }}
features:
  - registration
  - nginx-counting
  - metrics-sender
  - dataplane-status
extensions:
  - nginx-app-protect
  - nap-monitoring
nginx_app_protect:
  report_interval: 15s
  precompiled_publication: true
nap_monitoring:
  collector_buffer_size: {{ .Values.nginxAgent.napMonitoring.collectorBufferSize }}
  processor_buffer_size: {{ .Values.nginxAgent.napMonitoring.processorBufferSize }}
  syslog_ip: {{ .Values.nginxAgent.syslog.host }}
  syslog_port: {{ .Values.nginxAgent.syslog.port }}

{{ end -}}