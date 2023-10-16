{{/*
Copyright ZeroX.
*/}}
{{/*
Return the target Kubernetes version
*/}}
{{- define "common.capabilities.kubeVersion" -}}
{{- if .Values.global }}
    {{- if .Values.global.kubeVersion }}
    {{- .Values.global.kubeVersion -}}
    {{- else }}
    {{- default .Capabilities.KubeVersion.Version .Values.kubeVersion -}}
    {{- end -}}
{{- else }}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersion -}}
{{- end -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for RBAC resources.
*/}}
{{- define "common.capabilities.rbac.apiVersion" -}}
{{- if semverCompare "<1.17-0" (include "common.capabilities.kubeVersion" .) -}}
{{- print "rbac.authorization.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "rbac.authorization.k8s.io/v1" -}}
{{- end -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Service Monitor resources.
*/}}
{{- define "common.capabilities.serviceMonitor.apiVersion" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Network Policy resources.
*/}}
{{- define "common.capabilities.networkPolicy.apiVersion" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Horizontal Pod Autoscaler resources.
*/}}
{{- define "common.capabilities.autoscaling.apiVersion" -}}
{{- print "autoscaling/v2" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Cron Job resources.
*/}}
{{- define "common.capabilities.cronJob.apiVersion" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Deployment resources.
*/}}
{{- define "common.capabilities.deployment.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Ingress resources.
*/}}
{{- define "common.capabilities.ingress.apiVersion" -}}
{{- if semverCompare ">=1.19-0" (include "common.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1" -}}
{{- else if semverCompare ">=1.14-0" (include "common.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}