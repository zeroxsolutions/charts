{{/*
Copyright ZeroX.
*/}}

{{/*
Render image repository
{{- include "common.image.render" (dict "image" .Values.controller.image "_" $) -}}
*/}}
{{- define "common.image.render" -}}
{{- if and (hasKey . "image") (hasKey . "_") -}}
{{- $version := default ._.Chart.AppVersion .image.version -}}
{{- $registry := default "docker.io" .image.registry -}}
{{- $name := default ._.Chart.Name .image.name -}}
{{- printf "%s/%s:%s" $registry $name $version -}}
{{- else -}}
{{- fail "Invalid agruments common.image.render: require 2 args image and _ (context, please set is $)" -}}
{{- end -}}
{{- end -}}

{{- define "common.image" -}}
{{- include "common.image.render" (dict "image" .Values.controller.image "_" $) -}}
{{- end -}}
