
# Create EKS cluster
resource "aws_eks_cluster" "main" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.31"

  vpc_config {
    subnet_ids              = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    endpoint_private_access = true # Enable private endpoint for better security
    endpoint_public_access  = true
    public_access_cidrs    = ["0.0.0.0/0"] # Restrict public access if needed
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"] # Enable all log types

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Environment = "dev"
    Managed_by  = "terraform"
  }
}

# Create aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_nodes.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
    mapUsers = yamlencode([
      for user_arn in var.user_arns : {
        userarn  = user_arn
        username = split("/", user_arn)[1]
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [aws_eks_cluster.main]
}

# Install VPC CNI addon
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  configuration_values = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
      WARM_PREFIX_TARGET      = "1"
    }
  })

  depends_on = [aws_eks_cluster.main]
}

 # Create EKS node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  scaling_config {
    desired_size = 2
    max_size     = 3 # Increased for better scalability
    min_size     = 2
  }

  labels = {
    "role"        = "worker"
    "environment" = "dev"
  }

  # Enable auto-scaling
  update_config {
    max_unavailable = 1
  }

  launch_template {
    name    = aws_launch_template.eks_node_template.name
    version = aws_launch_template.eks_node_template.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry
  ]

  tags = {
    Environment = "dev"
    Managed_by  = "terraform"
  }
}

# Create Launch Template for EKS Node Group
resource "aws_launch_template" "eks_node_template" {
  name = "eks-node-group-template"
  description = "Launch template for EKS worker nodes"

  instance_type = "t3.medium"


  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "eks-node"
      Environment = "dev"
      Managed_by  = "terraform"
    }
  }

  tags = {
    Environment = "dev"
    Managed_by  = "terraform"
  }
}
