1. Add Helm repo

        helm repo add argo https://argoproj.github.io/argo-helm
        helm repo update
        
2. Install argocd

        kubectl create namespace argocd
        helm isntall argocd -n argocd argo/argo-cd \
          --set "server.extraArgs={--insecure}" \
          --set 'controller.tolerations[0].value'="system" \
          --set 'controller.tolerations[0].key'="component" \
          --set 'controller.tolerations[0].operator'='Equal' \
          --set 'controller.tolerations[0].effect'="NoSchedule" \
          --set controller.nodeSelector.nodeType=system \
          --set 'dex.tolerations[0].value'="system" \
          --set 'dex.tolerations[0].key'="component" \
          --set 'dex.tolerations[0].operator'='Equal' \
          --set 'dex.tolerations[0].effect'="NoSchedule" \
          --set dex.nodeSelector.nodeType=system \
          --set 'redis.tolerations[0].value'="system" \
          --set 'redis.tolerations[0].key'="component" \
          --set 'redis.tolerations[0].operator'='Equal' \
          --set 'redis.tolerations[0].effect'="NoSchedule" \
          --set redis.nodeSelector.nodeType=system \
          --set 'server.tolerations[0].value'="system" \
          --set 'server.tolerations[0].key'="component" \
          --set 'server.tolerations[0].operator'='Equal' \
          --set 'server.tolerations[0].effect'="NoSchedule" \
          --set server.nodeSelector.nodeType=system \
          --set 'repoServer.tolerations[0].value'="system" \
          --set 'repoServer.tolerations[0].key'="component" \
          --set 'repoServer.tolerations[0].operator'='Equal' \
          --set 'repoServer.tolerations[0].effect'="NoSchedule" \
          --set repoServer.nodeSelector.nodeType=system

- We set `server.extraArgs={--insecure}` so we can terminate SSL at load balancer
- For toleration, make sure you change with corrected value, or you can by pass. This make sure your service will be scheduled on node with toleration `system=component:NoSchedule`
