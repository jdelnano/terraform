variable name { type = string }
variable account_id { type = string }
variable delivery_policy { type = string }
variable protocol { type = string }
variable endpoint { type = string }

resource aws_sns_topic topic {
  name            = var.name
  delivery_policy = var.delivery_policy
}

resource aws_sns_topic_subscription sub {
  count = var.protocol != "email" ? 1 : 0

  topic_arn = aws_sns_topic.topic.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}

resource aws_sns_topic_policy policy_topic {
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data aws_iam_policy_document sns_topic_policy {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.topic.arn,
    ]

    sid = "__default_statement_ID"
  }
}

output name {
  value = aws_sns_topic.topic.id
}
