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
Return the appropriate apiVersion for ServiceMonitor resources.
*/}}
{{- define "common.capabilities.serviceMonitor.apiVersion" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for NetworkPolicy resources.
*/}}
{{- define "common.capabilities.networkPolicy.apiVersion" -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for HorizontalPodAutoscaler resources.
*/}}
{{- define "common.capabilities.autoscaling.apiVersion" -}}
{{- print "autoscaling/v2" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for CronJob resources.
*/}}
{{- define "common.capabilities.cronJob.apiVersion" -}}
{{- print "batch/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Deployment resources.
*/}}
{{- define "common.capabilities.deployment.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Service resources.
*/}}
{{- define "common.capabilities.service.apiVersion" -}}
{{- print "v1" -}}
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
{{/*
Return the appropriate apiVersion for ConfigMap resources.
*/}}
{{- define "common.capabilities.configMap.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for DaemonSet resources.
*/}}
{{- define "common.capabilities.daemonSet.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for StatefulSet resources.
*/}}
{{- define "common.capabilities.statefulSet.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for Secret resources.
*/}}
{{- define "common.capabilities.secret.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for ServiceAccount resources.
*/}}
{{- define "common.capabilities.serviceAccount.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for PersistentVolume resources.
*/}}
{{- define "common.capabilities.persistentVolume.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for CustomResourceDefinition resources.
*/}}
{{- define "common.capabilities.customResourceDefinition.apiVersion" -}}
{{- print "apiextensions.k8s.io/v1"  -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for GlobalConfiguration resources.
*/}}
{{- define "common.capabilities.globalConfiguration.apiVersion" -}}
{{- print "k8s.nginx.org/v1"  -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for PodDisruptionBudget resources.
*/}}
{{- define "common.capabilities.podDisruptionBudget.apiVersion" -}}
{{- print "policy/v1"  -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for ServiceMonitor resources.
*/}}
{{- define "common.capabilities.serviceMonitor.apiVersion" -}}
{{- print "monitoring.coreos.com/v1"  -}}
{{- end -}}