# account networking
module networking {
  source = "./networking"
}

# joechem staging infra
module staging-joechem {
  source = "./joechem"
  # staging vars
  name          = "staging-joechem"
  vpc_id        = module.networking.vpc_id
  env           = "staging"
  ami           = "ami-0986c2ac728528ac2"
  instance_type = "t3a.small"
  key_name      = "joechem-server"
  subnet_id     = module.networking.public_subnet_1_id
  asg_size      = 1
  volume        = 16
}

# joechem prod infra
module prod-joechem {
  source = "./joechem"
  # prod vars
  name          = "prod-joechem"
  vpc_id        = module.networking.vpc_id
  env           = "prod"
  ami           = "ami-0986c2ac728528ac2"
  instance_type = "t3a.small"
  key_name      = "joechem-server"
  subnet_id     = module.networking.public_subnet_1_id
  asg_size      = 1
  volume        = 16
}
