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
  }
}
