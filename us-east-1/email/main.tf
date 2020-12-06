variable domain { type = string }
variable route53_zone { type = string }

data aws_route53_zone zone {
  name         = "${var.route53_zone}."
  private_zone = false
}

resource aws_ses_domain_identity domain {
  domain = var.domain
}

resource aws_ses_domain_dkim dkim {
  domain = var.domain
}

# TODO: set up custom MAIL FROM subdomain--relying on default currently
#resource aws_ses_domain_mail_from from {
#  domain           = aws_ses_domain_identity.domain.domain
#  mail_from_domain = aws_ses_domain_identity.domain.domain
#}

resource aws_route53_record ses_domain_mail_from_mx {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = "1800"
  records = ["10 inbound-smtp.${var.region}.amazonaws.com"]
}

resource aws_route53_record dkim_record {
  count   = 3
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "1800"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource aws_route53_record verification_record {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "1800"
  records = [aws_ses_domain_identity.domain.verification_token]
}

// This resource is not needed since email was configured and
// verified by hand. Keeping here for reference.
#resource aws_ses_domain_identity_verification verification {
#  domain = aws_ses_domain_identity.domain.id
#
#  depends_on = [aws_route53_record.verification_record]
#}
