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

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.main.version
  sensitive   = false
}

output "cluster_certificate_authority" {
  description = "Certificate authority data for cluster authentication"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
  sensitive   = false
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  sensitive   = false
}

# # Output Node Group Information
# output "node_group_name" {
#   description = "Name of the EKS node group"
#   value       = aws_eks_node_group.main.node_group_name
#   sensitive   = false
# }

# output "node_group_status" {
#   description = "Status of the EKS node group"
#   value       = aws_eks_node_group.main.status
#   sensitive   = false
# }

# output "node_group_resources" {
#   description = "List of objects containing information about underlying resources of the node group"
#   value       = aws_eks_node_group.main.resources
#   sensitive   = false
# }

# # Output Network Information
# output "vpc_config" {
#   description = "VPC configuration for EKS cluster"
#   value       = aws_eks_cluster.main.vpc_config
#   sensitive   = false
# }

# output "cluster_role_arn" {
#   description = "ARN of the EKS cluster IAM role"
#   value       = aws_eks_cluster.main.role_arn
#   sensitive   = false
# }
