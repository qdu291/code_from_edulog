1. Add Helm repo

        helm repo add eks https://aws.github.io/eks-charts
        helm repo update
2. Install target group binding CRD

        kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
3. Install ALB Controller

        helm upgrade aws-load-balancer-controller eks/aws-load-balancer-controller \
          -n kube-system \
          --set clusterName=athena-eks-dev \
          --set serviceAccount.create=true \
          --set serviceAccount.name=aws-load-balancer-controller \
          --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::696952606624:role/dev-EksAlbControllerRole \
          --set hostNetwork=true \
          --set 'tolerations[0].value'="system" \
          --set 'tolerations[0].key'="component" \
          --set 'tolerations[0].effect'="NoSchedule" \
          --set 'tolerations[0].operator'='Equal' \
          --set nodeSelector.nodeType=system \
          
We set `hostNetwork=true ` because we are using custom CNI (Calico)
Remember to change role ARN & Cluster Name with the corrected role you created.
* For toleration, make sure you change with corrected value, or you can by pass. This make sure your service will be scheduled on node with toleration `system=component:NoSchedule`