# account networking
module networking {
  source = "./networking"
}

# alb
module alb {
  source = "./lb"

  name        = "joechem-alb"
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

# joechem staging infra
module staging-joechem {
  source = "./joechem"
  # staging vars
  name                  = "staging-joechem"
  vpc_id                = module.networking.vpc_id
  lb_sg_id              = module.alb.lb_sg_id
  env                   = "staging"
  ami                   = "ami-0986c2ac728528ac2"
  instance_type         = "t3a.small"
  key_name              = "joechem-server"
  subnet_ids            = [module.networking.public_subnet_1_id]
  asg_size              = 1
  volume                = 16
  http_target_group_arn = module.alb.target_group_arn
}

# s3 buckets
#module s3 {
#  source = "./s3"
#}
