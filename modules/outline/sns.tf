# Create SNS Topic
resource "aws_sns_topic" "outline_config" {
  name = "outline-config-topic"
}

# Create SNS Topic Subscription
resource "aws_sns_topic_subscription" "outline_config_email" {
  topic_arn = aws_sns_topic.outline_config.arn
  protocol  = "email"
  endpoint  = "kc.wan@one2.cloud"
}

resource "aws_iam_role_policy" "outline_sns_policy" {
  name = "outline-sns-policy"
  role = aws_iam_role.outline_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.outline_config.arn
        ]
      }
    ]
  })
}
