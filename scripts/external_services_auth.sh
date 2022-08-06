#/bin/bash

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