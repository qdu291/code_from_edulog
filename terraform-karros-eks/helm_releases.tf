### AWS ALB CONTROLLER HELM CHART ###
# resource "helm_release" "aws_alb_controller" {
#   depends_on = [module.eks_cluster]

#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.3.2" //https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/Chart.yaml

#   set {
#     name  = "clusterName"
#     value = local.eks_cluster_name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.eks_alb_controller_role.role_arn
#   }

#   set {
#     name  = "hostNetwork"
#     value = "true"
#   }
# }


### CERT MANAGER HELM CHART ###
# resource "helm_release" "cert_manager" {
#   depends_on = [module.eks_cluster]

#   name             = "cert-manager"
#   repository       = "https://charts.jetstack.io"
#   chart            = "cert-manager"
#   create_namespace = true
#   namespace        = "cert-manager"
#   version          = "1.6.0"

#   set {
#     name  = "installCRDs"
#     value = "true"
#   }

#   set {
#     name  = "webhook.hostNetwork"
#     value = "true"
#   }

#   set {
#     name  = "webhook.securePort"
#     value = "10260"
#   }
# }


### AWS CLUSTER AUTOSCALER HELM CHART ###
# resource "helm_release" "cluster_autoscaler" {
#   depends_on = [module.eks_cluster]

#   name       = "cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"
#   version    = "1.21.0"

#   set {
#     name  = "cloudProvider"
#     value = "aws"
#   }

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = local.eks_cluster_name
#   }

#   set {
#     name  = "awsRegion"
#     value = data.aws_region.current.name
#   }

#   set {
#     name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.eks_cluster_autoscaler_role.role_arn
#   }
# }

# # kubectl -n kube-system \ ???
# #     annotate deployment.apps/cluster-autoscaler \
# #     cluster-autoscaler.kubernetes.io/safe-to-evict="false"


### EXTERNAL HELM CHART ###
# resource "helm_release" "external_dns" {
#   name       = "external-dns"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "external-dns"

#   set {
#     name  = "provider"
#     value = "aws"
#   }

#   set {
#     name  = "\"sources"
#     value = "{service,ingress,istio-gateway,istio-virtualservice}\""
#   }

#   set {
#     name = "policy"
#     value = "upsert-only"
#   }

#   set {
#     name  = "podSecurityContext.fsGroup"
#     value = "65534"
#   }

#   set {
#     name  = "podSecurityContext.runAsUser"
#     value = "0"
#   }

#   set {
#     name  = "aws.zoneType"
#     value = "public"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.eks_external_dns_role.role_arn
#   }

#   set {
#     name  = "podAnnotations.iam\\.amazonaws\\.com/role"
#     value = module.eks_external_dns_role.role_arn
#   }
# }


### ARGOCD HELM CHART ###
# resource "helm_release" "argo_cd" {
#   depends_on = [module.eks_cluster]

#   name             = "argocd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   namespace        = "argocd"
#   create_namespace = true

#   ## This below setting is using for SSL termication at istio ingress
#   set {
#     name  = "server.extraArgs"
#     value = "{--insecure}"
#   }
# }
