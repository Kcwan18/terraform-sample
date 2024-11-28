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

output "istio_nlb_endpoint" {
  description = "The DNS name of the NLB created for the Istio ingress gateway"
  value       = module.istio.nlb_endpoint
  sensitive   = false
}

