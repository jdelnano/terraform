terraform {
  required_version = "> 0.13.0"
  backend s3 {
    bucket = "terraform-328959061259-us-west-2"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
