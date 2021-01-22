variable name { type = string }
variable vpc_id { type = string }
variable env { type = string }
variable ami { type = string }
variable instance_type { type = string }
variable key_name { type = string }
variable subnet_id { type = string }
variable asg_size { type = number }
variable volume { type = number }

locals {
  tags = {
    "Name" = var.name
  }
}
