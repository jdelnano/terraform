data aws_iam_policy_document assume_role {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource aws_iam_role role {
  name               = "joechem-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource aws_iam_instance_profile prof {
  name = "joechem-role"
  role = aws_iam_role.role.name
}

# s3 rw
data aws_iam_policy_document s3_rw {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::joechem-prod-db-backup", "arn:aws:s3:::joechem-deployment-files"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["arn:aws:s3:::joechem-prod-db-backup/*", "arn:aws:s3:::joechem-deployment-files/*"]
  }
}

resource aws_iam_policy s3 {
  name   = "joechem-${var.env}-s3-rw"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_rw.json
}

resource aws_iam_role_policy_attachment att_s3 {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.s3.arn
}

# ecr r
data aws_iam_policy_document ecr_r {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = ["*"]
  }
}

resource aws_iam_policy ecr {
  name   = "joechem-${var.env}-ecr-r"
  path   = "/"
  policy = data.aws_iam_policy_document.ecr_r.json
}

resource aws_iam_role_policy_attachment att_ecr {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.ecr.arn
}
