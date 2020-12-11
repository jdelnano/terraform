variable "region" {
  type    = string
  default = "us-east-1"
}

# DNS variables
variable joechem_io_domain_info {
  type = map(object({
    name        = string
    record_type = string
    records     = list(string)
    ttl         = number
  }))
  default = {
    "joechem.io" = {
      name        = "joechem.io"
      record_type = "A"
      records     = ["18.220.140.98"]
      ttl         = 300
    },
    "www.joechem.io" = {
      name        = "www.joechem.io"
      record_type = "CNAME"
      records     = ["joechem.io"]
      ttl         = 300
    },
    "staging.joechem.io" = {
      name        = "staging.joechem.io"
      record_type = "A"
      records     = ["18.219.89.47"]
      ttl         = 300
    },
    "www.staging.joechem.io" = {
      name        = "www.staging.joechem.io"
      record_type = "CNAME"
      records     = ["staging.joechem.io"]
      ttl         = 300
    },
    "soa" = {
      name        = "joechem.io"
      record_type = "SOA"
      records     = ["ns-1044.awsdns-02.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
      ttl         = 900
    },
    "ns" = {
      name        = "joechem.io"
      record_type = "NS"
      records     = ["ns-1044.awsdns-02.org.", "ns-720.awsdns-26.net.", "ns-1916.awsdns-47.co.uk.", "ns-197.awsdns-24.com."]
      ttl         = 172800
    },
  }
}

variable joechem_org_domain_info {
  type = map(object({
    name        = string
    record_type = string
    records     = list(string)
    ttl         = number
  }))
  default = {
    "joechem.org" = {
      name        = "joechem.org"
      record_type = "A"
      records     = ["18.220.140.98"]
      ttl         = 300
    },
    "www.joechem.org" = {
      name        = "www.joechem.org"
      record_type = "CNAME"
      records     = ["joechem.org"]
      ttl         = 300
    },
    "staging.joechem.org" = {
      name        = "staging.joechem.org"
      record_type = "A"
      records     = ["18.219.89.47"]
      ttl         = 300
    },
    "www.staging.joechem.org" = {
      name        = "www.staging.joechem.org"
      record_type = "CNAME"
      records     = ["staging.joechem.org"]
      ttl         = 300
    },
    "soa" = {
      name        = "joechem.org"
      record_type = "SOA"
      records     = ["ns-573.awsdns-07.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
      ttl         = 900
    },
    "ns" = {
      name        = "joechem.org"
      record_type = "NS"
      records     = ["ns-573.awsdns-07.net.", "ns-1084.awsdns-07.org.", "ns-379.awsdns-47.com.", "ns-1991.awsdns-56.co.uk."]
      ttl         = 172800
    },
  }
}
