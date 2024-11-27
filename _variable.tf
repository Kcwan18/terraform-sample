# Get current AWS account information
data "aws_caller_identity" "current" {}

# AWS provider configuration
variable "aws_provider" {
  description = "AWS provider configuration containing region and profile"
  type = object({
    region  = string
    profile = string
  })
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_provider.region))
    error_message = "Region must be a valid AWS region name (e.g. us-west-2)"
  }
}

# Slack webhook URL for notifications
variable "slack_webhook_url" {
  description = "Webhook URL for Slack notifications"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^https://hooks.slack.com/services/", var.slack_webhook_url))
    error_message = "Slack webhook URL must start with https://hooks.slack.com/services/"
  }
}

# User ARNs for cluster access
variable "user_arns" {
  description = "List of IAM user ARNs to grant EKS cluster admin access"
  type        = list(string)
  validation {
    condition     = alltrue([
      for arn in var.user_arns : 
      can(regex("^arn:aws:(iam|sts)::[0-9]{12}:(user|role|assumed-role)/", arn))
    ])
    error_message = "All ARNs must be valid AWS IAM or STS ARNs in the format arn:aws:(iam|sts)::<account_id>:(user|role|assumed-role)/"
  }
}

variable "enable_kiali" {
  type        = bool
  default     = false
  description = "Enable Kiali deployment in EKS cluster"
}

variable "enable_bookinfo" {
  type        = bool
  default     = false
  description = "Enable Bookinfo sample application deployment in EKS cluster"
}