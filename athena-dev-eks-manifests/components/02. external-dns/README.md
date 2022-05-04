1. Add Helm repo

        helm repo add bitnami https://charts.bitnami.com/bitnami
        helm repo update
2. Install

helm install external-dns bitnami/external-dns \
  -n external-dns \
  --create-namespace \
  --set provider=aws \
  --set "sources={service,ingress}" \
  --set policy=upsert-only \
  --set podSecurityContext.fsGroup=65534 \
  --set podSecurityContext.runAsUser=0 \
  --set aws.zoneType=public \
  --set txtOwnerId=my-hostedzone-identifier \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::696952606624:role/dev-EksExternalDnsRole \
  --set podAnnotations."iam\.amazonaws\.com/role"=arn:aws:iam::696952606624:role/dev-EksExternalDnsRole \
  --set 'tolerations[0].key'="component" \
  --set 'tolerations[0].effect'="NoSchedule" \
  --set 'tolerations[0].value'="system" \
  --set 'tolerations[0].operator'='Equal' \
  --set nodeSelector.nodeType=system

* Remember to change role ARN with the corrected role you created
* For toleration, make sure you change with corrected value, or you can by pass. This make sure your service will be scheduled on node with toleration `system=component:NoSchedule`

* Install externalDNS private

helm install external-dns-private bitnami/external-dns         --namespace external-dns \
--set provider=aws \
--set "sources={service,ingress}" \
--set policy=upsert-only \
--set podSecurityContext.fsGroup=65534 \
--set podSecurityContext.runAsUser=0 \
--set aws.zoneType=private \
--set txtOwnerId=my-hostedzone-identifier \
--set annotationFilter=alb.ingress.kubernetes.io/scheme=internal \
--set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::696952606624:role/dev-EksExternalDnsRole \
--set podAnnotations."iam\.amazonaws\.com/role"=arn:aws:iam::696952606624:role/dev-EksExternalDnsRole \
--set 'tolerations[0].value'="system" \
--set 'tolerations[0].key'="component" \
--set 'tolerations[0].effect'="NoSchedule" \
--set 'tolerations[0].operator'='Equal' \
--set nodeSelector.nodeType=system