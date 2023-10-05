{{- /*
Copyright ZeroX.
*/}}
{{- define "common.serviceAccountName" }}
{{- if .Values.controller.serviceAccount.create }}
{{- default (include "common.fullname" .) .Values.controller.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.controller.serviceAccount.name }}
{{- end }}
{{- end }}