#!/bin/bash

#Variables

GRAFANA_URL=$(kubectl get gateway grafana-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')
KIALI_URL=$(kubectl get gateway kiali-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')
PROMETHEUS_URL=$(kubectl get gateway prometheus-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')
JAEGER_URL=$(kubectl get gateway tracing-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')

#Show URLs
echo [EXTERNAL URLS]
echo http://$GRAFANA_URL
echo http://$KIALI_URL
echo http://$PROMETHEUS_URL
echo http://$JAEGER_URL