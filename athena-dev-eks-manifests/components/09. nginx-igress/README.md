## OFFICIAL
### Internal ingress
helm install external-ingress stable/nginx-ingress \
  --set controller.service.externalTrafficPolicy=Local \
  --set rbac.create=true \
  --set controller.hostNetwork=true \
  --set 'controller.tolerations[0].value'="system" \
  --set 'controller.tolerations[0].key'="component" \
  --set 'controller.tolerations[0].operator'='Equal' \
  --set 'controller.tolerations[0].effect'="NoSchedule" \
  --set controller.nodeSelector.nodeType=system \
  --set controller.admissionWebhooks.patch.nodeSelector.nodeType-=system \
  --set 'defaultBackend.tolerations[0].value'="system" \
  --set 'defaultBackend.tolerations[0].key'="component" \
  --set 'defaultBackend.tolerations[0].operator'='Equal' \
  --set 'defaultBackend.tolerations[0].effect'="NoSchedule" \
  --set defaultBackend.nodeSelector.nodeType=system \
  --namespace ingress
  


1. sudo helm repo add nginx-stable https://helm.nginx.com/stable
sudo helm repo add ingress-nginx \
  https://kubernetes.github.io/ingress-nginx


2. sudo helm repo update
3. create values.yaml file
4. 
helm install external ingress-nginx/ingress-nginx \
  --namespace ingress \
  --version 4.0.15 \
  --values values.yaml



### https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/

https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/

helm install athena-dev-ingress nginx-stable/nginx-ingress \
  --set controller.hostNetwork=true \
  --namespace ingress






