variable "vpc_id" { type = string }
variable "name" { type = string }
variable "domain" { type = string }
variable "bucket_name" { type = string }
variable "description" { type = string }
variable "subnets" { type = list(string) }
variable "tags" { type = map }
variable "internal" {
  type    = bool
  default = false
}
variable "load_balancer_type" {
  type    = string
  default = "application"
}

########################
# Security Group Stuff #
########################
resource aws_security_group lb {
  name_prefix = "${var.name}-"
  vpc_id      = var.vpc_id
  description = var.description
  lifecycle {
    create_before_destroy = true
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
resource aws_security_group_rule http {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}
resource aws_security_group_rule https {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

#######################
# Load Balancer Stuff #
#######################
resource aws_lb lb {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.subnets

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.b.bucket
    enabled = true
  }
}

resource aws_lb_target_group http {
  name     = "${var.name}-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 15
    path                = "/ping"
    protocol            = "HTTP"
    matcher             = 200
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
}

resource aws_acm_certificate io {
  domain_name               = var.domain
  subject_alternative_names = ["www.${var.domain}"]
  validation_method         = "DNS"
  tags                      = var.tags
}

# staging
resource aws_acm_certificate staging_io {
  domain_name               = "staging.${var.domain}"
  subject_alternative_names = ["www.staging.${var.domain}"]
  validation_method         = "DNS"
  tags                      = var.tags
}

# org
resource aws_acm_certificate org {
  domain_name               = "joechem.org"
  subject_alternative_names = ["www.joechem.org"]
  validation_method         = "DNS"
  tags                      = var.tags
}

# staging org
resource aws_acm_certificate staging_org {
  domain_name               = "staging.joechem.org"
  subject_alternative_names = ["www.staging.joechem.org"]
  validation_method         = "DNS"
  tags                      = var.tags
}

# joechem.org
resource aws_lb_listener_certificate org {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.org.arn
}

# staging.joechem.io
resource aws_lb_listener_certificate staging_io {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.staging_io.arn
}

# staging.joechem.org
resource aws_lb_listener_certificate staging_org {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.staging_org.arn
}

resource aws_lb_listener https {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.io.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    target_group_arn = aws_lb_target_group.http.arn
    type             = "forward"
  }
}

resource aws_lb_listener http {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource aws_lb_listener_rule https_org {
  listener_arn = aws_lb_listener.https.arn

  action {
    type = "redirect"

    redirect {
      host        = "joechem.io"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["joechem.org", "www.joechem.org"]
    }
  }
}


#########################
# S3 Bucket For Logging #
#########################
resource aws_s3_bucket b {
  bucket = var.bucket_name
  acl    = "private"
}

data aws_iam_policy_document logging {
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.b.id}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.b.id}"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource aws_s3_bucket_policy p {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.logging.json
}
