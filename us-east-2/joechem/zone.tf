data "terraform_remote_state" "webs" {
  backend = "local"

  config {
    path = "../useast1/terraform.tfstate"
  }
}

resource "aws_route53_zone" "main_zone" {
  name = "joechem.org."
}

# Declare name servers for the hosted zone
resource "aws_route53_record" "prod-ns" {
  zone_id = "${aws_route53_zone.main_zone.zone_id}"
  name    = "joechem.org"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.main_zone.name_servers.0}",
    "${aws_route53_zone.main_zone.name_servers.1}",
    "${aws_route53_zone.main_zone.name_servers.2}",
    "${aws_route53_zone.main_zone.name_servers.3}",
  ]
}

# Declare A record for redirection 
resource "aws_route53_record" "www-alias" {
  zone_id = "${aws_route53_zone.main_zone.zone_id}"
  name    = "joechem.org"
  type    = "A"

  alias {
    name                   = "${data.terraform_remote_state.webs.elb-dns-name}" 
    zone_id                = "${data.terraform_remote_state.webs.elb-zone-id}"
    evaluate_target_health = true
  }
}

# Declare A record for redirection 
resource "aws_route53_record" "fqdn-alias" {
  zone_id = "${aws_route53_zone.main_zone.zone_id}"
  name    = "www.joechem.org"
  type    = "A"

  alias {
    name                   = "${aws_route53_record.www-alias.name}" 
    zone_id                = "${aws_route53_zone.main_zone.zone_id}"
    evaluate_target_health = true
  }
}

output "cert_arn" {
  value = "${aws_acm_certificate_validation.cert.certificate_arn}"
}
