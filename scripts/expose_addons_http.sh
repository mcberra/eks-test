#!/bin/bash

#Create variables
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
export INGRESS_DOMAIN=$(dig $INGRESS_HOST | sed -n '14p' | cut -d " " -f 5  | cut -f 2).nip.io
#export INGRESS_DOMAIN=$(dig $INGRESS_HOST | sed -n '15p' | cut -d " " -f 5).nip.io

#Expose addons HTTP

#GRAFANA
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: grafana-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingress
  servers:
  - port:
      number: 80
      name: http-grafana
      protocol: HTTP
    hosts:
    - "grafana.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana-vs
  namespace: istio-system
spec:
  hosts:
  - "grafana.${INGRESS_DOMAIN}"
  gateways:
  - grafana-gateway
  http:
  - route:
    - destination:
        host: grafana
        port:
          number: 3000
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: grafana
  namespace: istio-system
spec:
  host: grafana
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF

#KIALI
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kiali-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingress
  servers:
  - port:
      number: 80
      name: http-kiali
      protocol: HTTP
    hosts:
    - "kiali.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: kiali-vs
  namespace: istio-system
spec:
  hosts:
  - "kiali.${INGRESS_DOMAIN}"
  gateways:
  - kiali-gateway
  http:
  - route:
    - destination:
        host: kiali
        port:
          number: 20001
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: kiali
  namespace: istio-system
spec:
  host: kiali
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF

#PROMETHEUS
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: prometheus-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingress
  servers:
  - port:
      number: 80
      name: http-prom
      protocol: HTTP
    hosts:
    - "prometheus.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: prometheus-vs
  namespace: istio-system
spec:
  hosts:
  - "prometheus.${INGRESS_DOMAIN}"
  gateways:
  - prometheus-gateway
  http:
  - route:
    - destination:
        host: prometheus-server
        port:
          number: 9090
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: prometheus
  namespace: istio-system
spec:
  host: prometheus
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF

#TRACING
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: tracing-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingress
  servers:
  - port:
      number: 80
      name: http-tracing
      protocol: HTTP
    hosts:
    - "tracing.${INGRESS_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: tracing-vs
  namespace: istio-system
spec:
  hosts:
  - "tracing.${INGRESS_DOMAIN}"
  gateways:
  - tracing-gateway
  http:
  - route:
    - destination:
        host: jaeger-tracing-query
        port:
          number: 80
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: tracing
  namespace: istio-system
spec:
  host: tracing
  trafficPolicy:
    tls:
      mode: DISABLE
---
EOF

#Patch services with correct port

#Grafana
kubectl patch svc grafana --type json -p='[{"op": "replace", "path": "/spec/ports/0/port", "value": 3000}]' -n istio-system

#Prometheus
kubectl patch svc prometheus-server --type json -p='[{"op": "replace", "path": "/spec/ports/0/port", "value": 9090}]' -n istio-system

#Jaeger
kubectl patch svc jaeger-tracing-query --type json -p='[{"op": "replace", "path": "/spec/ports/0/targetPort", "value": 16686}]' -n istio-system

#Update Kiali cm with external services URLs
cat <<EOF | kubectl replace -f -
apiVersion: v1
data:
  config.yaml: |
    auth:
      openid: {}
      openshift:
        client_id_prefix: kiali
      strategy: token
    deployment:
      accessible_namespaces:
      - '**'
      additional_service_yaml: {}
      affinity:
        node: {}
        pod: {}
        pod_anti: {}
      configmap_annotations: {}
      custom_secrets: []
      host_aliases: []
      hpa:
        api_version: autoscaling/v2
        spec: {}
      image_digest: ""
      image_name: quay.io/kiali/kiali
      image_pull_policy: Always
      image_pull_secrets: []
      image_version: v1.54.0
      ingress:
        additional_labels: {}
        class_name: nginx
        override_yaml:
          metadata: {}
      instance_name: kiali
      logger:
        log_format: text
        log_level: info
        sampler_rate: "1"
        time_field_format: 2006-01-02T15:04:05Z07:00
      namespace: istio-system
      node_selector: {}
      pod_annotations: {}
      pod_labels: {}
      priority_class_name: ""
      replicas: 1
      resources:
        limits:
          memory: 1Gi
        requests:
          cpu: 10m
          memory: 64Mi
      secret_name: kiali
      service_annotations: {}
      service_type: ""
      tolerations: []
      version_label: v1.54.0
      view_only_mode: false
    external_services:
      prometheus:
        url: http://prometheus.${INGRESS_DOMAIN}
      grafana:
        url: http://grafana.${INGRESS_DOMAIN}
      tracing:
        url: http://tracing.${INGRESS_DOMAIN}
      custom_dashboards:
        discovery_auto_threshold: 10
        discovery_enabled: "auto"
        enabled: true
        is_core: false
        namespace_label: "namespace"
      istio:
        component_status:
          components:
          - app_label: "istiod"
            is_core: true
            is_proxy: false
          - app_label: "istio-ingressgateway"
            is_core: true
            is_proxy: true
            # default: namespace is undefined
            namespace: istio-ingressgateway
    identity:
      cert_file: ""
      private_key_file: ""
    istio_namespace: istio-system
    kiali_feature_flags:
      certificates_information_indicators:
        enabled: true
        secrets:
        - cacerts
        - istio-ca-secret
      clustering:
        enabled: true
      disabled_features: []
      validations:
        ignore:
        - KIA1201
    login_token:
      signing_key: gSEuo0yPicgfkuAH
    server:
      metrics_enabled: true
      metrics_port: 9090
      port: 20001
      web_root: /kiali
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: kiali
    meta.helm.sh/release-namespace: istio-system
  labels:
    app: kiali
    app.kubernetes.io/instance: kiali
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: kiali
    app.kubernetes.io/part-of: kiali
    app.kubernetes.io/version: v1.54.0
    helm.sh/chart: kiali-server-1.54.0
    version: v1.54.0
  name: kiali
  namespace: istio-system
EOF

#Restart Kiali
kubectl scale deploy kiali --replicas 0 -n istio-system
sleep 5
kubectl scale deploy kiali --replicas 1 -n istio-system
#Domains URLs
printf "\n"
echo [EXTERNAL SERVICES]
echo http://kiali.${INGRESS_DOMAIN}
echo http://prometheus.${INGRESS_DOMAIN}
echo http://grafana.${INGRESS_DOMAIN}
echo http://tracing.${INGRESS_DOMAIN}
printf "\n"
#Get and store Kiali token
echo [KIALI TOKEN]
kubectl get secret -n istio-system $(kubectl get sa kiali -n istio-system -o "jsonpath={.secrets[0].name}") -o jsonpath={.data.token} | base64 -d
#Get Grafana password
printf "\n"
printf "\n"
echo [GRAFANA PASSWORD]
kubectl get secrets grafana -n istio-system -ojsonpath='{.data.admin-password}' | base64 -d
printf "\n"
printf "\n"
#Add shortcuts to ec2-user profile on .bashrc file
echo ext_urls='"sh /home/ec2-user/eks-test/scripts/external_services_urls.sh"' >> /home/ec2-user/.bashrc
echo ext_auth='"sh /home/ec2-user/eks-test/scripts/external_services_auth.sh"' >> /home/ec2-user/.bashrc