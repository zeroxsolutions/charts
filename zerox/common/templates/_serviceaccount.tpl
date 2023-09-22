{{/*
Copyright ZeroX.
*/}}
{{- define "common.serviceAccountName" . }}
{{- if .Values.controller.serviceAccount.name }}
{{ print .Values.controller.serviceAccount.name }}
{{- end }}