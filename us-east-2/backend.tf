terraform {
  required_version = "> 0.13.0"
  backend s3 {
    bucket = "terraform-328959061259-us-east-2"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
