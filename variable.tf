variable "aws_provider" {
  type = object({
    region = string
  })
}

variable "slack_webhook_url" {
  type = string
}
