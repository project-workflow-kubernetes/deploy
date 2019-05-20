{{- define "workflow.command" -}}
{{- join "," .Values.stateful.command }}
{{- end -}}