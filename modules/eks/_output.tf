# Output EKS Cluster Information
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
  sensitive   = false
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
  sensitive   = false
}

output "cluster_config" {
  description = "EKS cluster configuration for provider configuration"
  value = {
    certificate_authority = aws_eks_cluster.main.certificate_authority
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.main.name]
      command     = "aws"
    }
  }
  sensitive = true
}

# output "istio_nlb_endpoint" {
#   description = "The DNS name of the NLB created for the Istio ingress gateway"
#   value       = module.istio.nlb_endpoint
#   sensitive   = false
# }

