{{/*
Copyright ZeroX.
*/}}

{{/*
Render image repository
{{- include "common.image.render" (dict "image" .Values.image "context" $) -}}
*/}}
{{- define "common.image.render" -}}
{{- if and (hasKey . "image") (hasKey . "context") -}}
{{- $repository := default .context.Chart.Name .image.repository -}}
{{- $tag := default .context.Chart.AppVersion .image.tag -}}
{{- $image := printf "%s:%s" $repository $tag -}}
{{- if not (empty .image.registry) -}}
{{- $image = printf "%s/%s" .image.registry $image -}}
{{- end -}}
{{- print $image -}}
{{- else -}}
{{- fail "Invalid agruments common.image.render: require 2 args image and context (please set is $)" -}}
{{- end -}}
{{- end -}}

{{- define "common.image" -}}
{{- include "common.image.render" (dict "image" .Values.image "context" $) -}}
{{- end -}}
