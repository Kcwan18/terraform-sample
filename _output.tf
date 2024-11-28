output "k3s_module_output" {
  description = "Commands to interact with K3s cluster"
  value = {
    "ssh_command"     = "ssh -i 'ssh-key/k3s-key.pem' ec2-user@${module.k3s.instance_public_dns}"
    "check_user_data" = "cat /var/log/cloud-init-output.log"
  }
  sensitive = false

}

output "outline_module_output" {
  description = "Commands to interact with Outline server"
  value = {
    "ssh_command"     = "ssh -i 'ssh-key/outline-key.pem' ec2-user@${module.outline.instance_public_dns}"
    "check_user_data" = "cat /var/log/cloud-init-output.log"
  }
  sensitive = false

}

output "eks_module_output" {
  description = "Commands to interact with EKS cluster"
  value = {
    # "cluster_endpoint" = module.eks.cluster_endpoint
    "connect_command" = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_provider.region}"
    "istio_nlb_endpoint" = module.eks.istio_nlb_endpoint
  }
}
