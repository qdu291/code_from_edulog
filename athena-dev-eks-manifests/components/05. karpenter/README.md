1. Add repo

        helm repo add karpenter https://charts.karpenter.sh
        helm repo update
2. Install
        kubectl create namespace karpenter
        helm upgrade karpenter karpenter/karpenter --namespace karpenter \
          --set serviceAccount.create=true --version 0.5.3 \
          --set controller.clusterName=athena-eks-dev \
          --set controller.clusterEndpoint=$(aws eks describe-cluster --name athena-eks-dev --query "cluster.endpoint" --output json --region us-east-2 --profile athena) \
          --set webhook.hostNetwork=true \
          --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::696952606624:role/dev-EksKarpenterRole \
          --set 'controller.tolerations[0].value'="system" \
          --set 'controller.tolerations[0].key'="component" \
          --set 'controller.tolerations[0].operator'='Equal' \
          --set 'controller.tolerations[0].effect'="NoSchedule" \
          --set controller.nodeSelector.nodeType=system \
          --set 'webhook.tolerations[0].value'="system" \
          --set 'webhook.tolerations[0].key'="component" \
          --set 'webhook.tolerations[0].operator'='Equal' \
          --set 'webhook.tolerations[0].effect'="NoSchedule" \
          --set webhook.nodeSelector.nodeType=system \
          --wait

  - Set `webhook.hostNetwork=true ` because we are using custom CNI (Calico)
  - Modify your cluster name in `controller.clusterName` and `controller.clusterEndpoint`
  - Modify region and profile (applied for AWS CLI multi profiles)
  - Modify role ARN
  - For toleration, make sure you change with corrected value, or you can by pass. This make sure your service will be scheduled on node with toleration `system=component:NoSchedule`
3. Apply a provision CRD

cat <<EOF | kubectl apply -f -
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: system
  namespace: karpenter
spec:
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["on-demand"]
    - key: "node.kubernetes.io/instance-type" 
      operator: In
      values: ["t3.medium"]
    - key: "topology.kubernetes.io/zone" 
      operator: In
      values: ["us-east-2a", "us-east-2b", "us-east-2c"]
  labels:
    nodeType: system
  taints:
    - key: component
      value: system
      effect: NoSchedule
  limits:
    resources:
      cpu: 1000
  provider:
    instanceProfile: eks-f8bf1449-9a85-83fd-b4d6-0aca285344da
    securityGroupSelector:
      kubernetes.io/cluster/athena-eks-dev: 'owned'
  ttlSecondsAfterEmpty: 30
EOF
- Modify `node.kubernetes.io/instance-type`
- Modify `topology.kubernetes.io/zone`
- Modify instance profile (check in EC2 console)
- Modify `securityGroupSelector` with the tag in security group
- Modify `launchTemplate` (check in ASG console)

4. Create provisioner for Scheduling nodes
cat <<EOF | kubectl apply -f -
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: scheduling-vn
  namespace: karpenter
spec:
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["on-demand"]
    - key: "node.kubernetes.io/instance-type" 
      operator: In
      values: ["r5.large"]
    - key: "topology.kubernetes.io/zone" 
      operator: In
      values: ["us-east-2a", "us-east-2b", "us-east-2c"]
  labels:
    nodeType: scheduling-vn
  taints:
    - key: scheduling
      value: vn
      effect: NoSchedule
  limits:
    resources:
      cpu: 1000
  provider:
    instanceProfile: eks-f8bf1449-9a85-83fd-b4d6-0aca285344da
    securityGroupSelector:
      Name: 'athena-eks-dev-eks_worker_sg'
      kubernetes.io/cluster/athena-eks-dev: 'owned'
  ttlSecondsAfterEmpty: 30
EOF

1. Modify: labels to match required timezone
2. Modify: Taints value to match required timezone