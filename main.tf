

module "k3s" {
  source = "./modules/k3s"
  slack_webhook_url = var.slack_webhook_url
}

module "outline" {
  source = "./modules/outline"
  slack_webhook_url = var.slack_webhook_url
}

module "eks" {
  source = "./modules/eks"
  slack_webhook_url = var.slack_webhook_url
  user_arns        = var.user_arns
}

