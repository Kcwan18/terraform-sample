variable "aws_provider" {
  type = object({
    region = string
    profile = string
  })
}

variable "slack_webhook_url" {
  type = string
}
