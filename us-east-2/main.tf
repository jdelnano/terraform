# account networking
module networking {
  source = "./networking"
}

# alb
module alb {
  source = "./lb"

  name = "joechem-alb"
  # need to explicitly add 2nd cert/ssl stuff for joechem.org
  # add rules for staging.* domains
  domain      = "joechem.io"
  bucket_name = "joechem-alb-access-loggging"
  description = "joechem-alb"
  vpc_id      = module.networking.vpc_id
  subnets     = [module.networking.public_subnet_1_id, module.networking.private_subnet_2_id]
  tags        = var.tags
}

# joechem prod infra
#module prod-joechem {
#  source = "./joechem"
#  # prod vars
#}

## joechem staging infra
#module staging-joechem {
#  source = "./joechem"
#  # staging vars
#}
#
# s3 buckets
#module s3 {
#  source = "./s3"
#}
