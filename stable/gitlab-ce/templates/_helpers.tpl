
{{/*
Return PostgreSQL URL
*/}}
{{- define "gitlab-ce.postgres.url" -}}
{{- printf "" }}
{{- end -}}

{{/*
Return fullname of PostgreSQL
*/}}
{{- define "gitlab-ce.postgres.fullname" -}}
{{- print (default (printf "%s-postgres" (include "common.names.fullname" .)) .Values.postgres.fullname) -}}
{{- end -}}

{{/*
Return name of PostgreSQL
*/}}
{{- define "gitlab-ce.postgres.name" -}}
{{- print (default (printf "%s-postgres" (include "common.names.name" .)) .Values.postgres.name) -}}
{{- end -}}

{{/*
Return redis url
*/}}
{{- define "gitlab-ce.redis-ha.url" -}}
{{- if not .Values.redis.enabled }}
{{- else }}

{{- end }}
{{- end -}}

{{/*
Return redis ha fullname
*/}}
{{- define "gitlab-ce.redis-ha.fullname" -}}
{{- print "%s-%s" (include "common.names.fullname".) "redis-ha" -}}
{{- end -}}
{{/*
Return redis ha namespace
*/}}
{{- define "gitlab-ce.redis-ha.namespace"-}}
{{- default .Release.Namespace .Values.redis-ha.namespaceOverride |  -}}
{{- end -}}