{{/*
Copyright ZeroX.
*/}}

{{- define "mysql.primary.fullname" -}}
{{- default (include "common.fullname" .) .Values.primary.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
