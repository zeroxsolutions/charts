{{/*
Copyright ZeroX.
*/}}

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
{{- print (default (printf "%s-postgres" (include "common.fullname" .)) .Values.postgres.fullname) -}}
{{- end -}}

{{/*
Return name of PostgreSQL
*/}}
{{- define "gitlab-ce.postgres.name" -}}
{{- print (default (printf "%s-postgres" (include "common.name" .)) .Values.postgres.name) -}}
{{- end -}}
