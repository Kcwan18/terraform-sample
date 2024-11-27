module "istio" {
  source = "./add-on/istio"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

# module "storage_class" {
#   source = "./add-on/storage-class"
#   cluster_oidc_issuer_url = aws_eks_cluster.main.identity[0].oidc[0].issuer
# }

# module "nginx" {
#   source = "./add-on/nginx"
# }
