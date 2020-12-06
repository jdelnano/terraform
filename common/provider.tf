provider aws {
  version = "~> 3.0"
  region  = var.region
}

data aws_caller_identity current {}
