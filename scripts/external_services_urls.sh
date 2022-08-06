#!/bin/bash

#Variables

GRAFANA_URL=$(kubectl get gateway grafana-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')
KIALI_URL=$(kubectl get gateway kiali-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')
PROMETHEUS_URL=$(kubectl get gateway prometheus-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')
JAEGER_URL=$(kubectl get gateway tracing-gateway -n istio-system -ojsonpath='{.spec.servers[0].hosts[0]}')

#Show URLs
echo [EXTERNAL URLS]
echo $GRAFANA_URL
echo $KIALI_URL
echo $PROMETHEUS_URL
echo $JAEGER_URL