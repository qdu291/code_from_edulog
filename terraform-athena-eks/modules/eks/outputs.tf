output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_kubeconfig" {
  value = module.eks.kubeconfig
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}
