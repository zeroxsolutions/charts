{{/*
Copyright ZeroX.
*/}}

{{/*
Create the name of the service account to use
*/}}
{{- define "common.serviceAccount.name" }}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}