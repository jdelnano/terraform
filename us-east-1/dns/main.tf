# module input variables
variable domain {
  type = string
}

variable records {
  type = map(object({
    name        = string
    record_type = string
    records     = list(string)
    ttl         = number
  }))
}

# resources
resource aws_route53_zone zone {
  name = var.domain
}
resource aws_route53_record record {
  for_each = var.records

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.record_type
  records = each.value.records
  ttl     = each.value.ttl
}
