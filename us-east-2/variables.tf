variable "region" {
  type    = string
  default = "us-east-2"
}

variable "network_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "nat_gateway_ip" {
  type = string
  # TODO:  double check what this IP should be 
  default = "10.0.4.1"
}

variable "subnets" {
  type = list(object({
    az                      = string
    cidr                    = string
    tag_name                = string
    map_public_ip_on_launch = bool
  }))
  default = [
    {
      az                      = "us-east-2a"
      cidr                    = "10.0.0.0/22"
      tag_name                = "public-subnet-1"
      map_public_ip_on_launch = true
    },
    {
      az                      = "us-east-2b"
      cidr                    = "10.0.4.0/22"
      tag_name                = "public-subnet-2"
      map_public_ip_on_launch = true
    },
    {
      az                      = "us-east-2a"
      cidr                    = "10.0.8.0/22"
      tag_name                = "private-subnet-1"
      map_public_ip_on_launch = false
    },
    {
      az                      = "us-east-2b"
      cidr                    = "10.0.12.0/22"
      tag_name                = "private-subnet-2"
      map_public_ip_on_launch = false
    }
  ]
}

# retrieve public subnet used for NAT
locals {
  public_subnet_1_cidr  = var.subnets[0]["cidr"]
  public_subnet_2_cidr  = var.subnets[1]["cidr"]
  private_subnet_1_cidr = var.subnets[2]["cidr"]
  private_subnet_2_cidr = var.subnets[3]["cidr"]
}
