provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  region = var.region
  name   = var.name

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
  }
}