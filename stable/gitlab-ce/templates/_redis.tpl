{{/*
Copyright ZeroX.
*/}}

{{/*
Return redis url
*/}}
{{- define "gitlab-ce.redis.url" -}}
{{- if not .Values.redis.enabled }}
{{- else }}

{{- end }}
{{- end -}}
