resource "aws_acm_certificate" "cert" {
  domain_name = "joechem.org"
  validation_method = "EMAIL"
  tags {
    Environment = "prod"
  }
}

#resource "aws_route53_record" "cert_validation" {
#  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
#  type = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
#  zone_id = "${aws_route53_zone.main_zone.id}"
#  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
#  ttl = 60
#}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
}
