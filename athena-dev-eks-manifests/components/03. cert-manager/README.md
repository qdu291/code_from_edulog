1. Add Helm repo

        helm repo add jetstack https://charts.jetstack.io
        helm repo update
2. Install cert-manager to work with CNI (hostNetwork = true) 

        helm upgrade cert-manager jetstack/cert-manager \
                --namespace cert-manager \
                --create-namespace \
                --version v1.6.0 \
                --set installCRDs=true \
                --set webhook.hostNetwork=true \
                --set webhook.securePort=10260 \
                --set 'tolerations[0].value'="system" \
                --set 'tolerations[0].key'="component" \
                --set 'tolerations[0].effect'="NoSchedule" \
                --set 'tolerations[0].operator'='Equal' \
                --set nodeSelector.nodeType=system \
                --set 'webhook.tolerations[0].value'="system" \
                --set 'webhook.tolerations[0].key'="component" \
                --set 'webhook.tolerations[0].effect'="NoSchedule" \
                --set 'webhook.tolerations[0].operator'='Equal' \
                --set webhook.nodeSelector.nodeType=system \
                --set 'cainjector.tolerations[0].value'="system" \
                --set 'cainjector.tolerations[0].key'="component" \
                --set 'cainjector.tolerations[0].effect'="NoSchedule" \
                --set 'cainjector.tolerations[0].operator'='Equal' \
                --set cainjector.nodeSelector.nodeType=system

* For toleration, make sure you change with corrected value, or you can by pass. This make sure your service will be scheduled on node with toleration `system=component:NoSchedule`
