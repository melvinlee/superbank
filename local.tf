provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  region      = var.region
  name        = var.name
  environment = var.environment
  cost_centre = var.cost_centre


  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  s3_bucket_name = "${local.name}-vpc-flow-logs-to-s3"

  tags = {
    app         = local.name
    environment = local.environment
    cost_centre = local.cost_centre
  }
}
