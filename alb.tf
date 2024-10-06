##################################################################
# Application Load Balancer (ALB)
# This module deploys an Application Load Balancer (ALB) in AWS and configures it to listen on port 80 and 443.
##################################################################

# data "aws_acm_certificate" "issued" {
#   domain   = var.domain_name
#   statuses = ["ISSUED"]
# }

module "self_signed_cert" {
  source = "./modules/self-signed-acm"

  create_certificate = var.create_self_signed_cert
  domain_name        = var.domain_name
  organization       = var.organization
} 

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name    = "${local.name}-${local.environment}-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  access_logs = {
    bucket = module.log_bucket.s3_bucket_id
    prefix = "access-logs"
  }

  connection_logs = {
    bucket  = module.log_bucket.s3_bucket_id
    enabled = true
    prefix  = "connection-logs"
  }

  client_keep_alive = 7200

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn =  var.create_self_signed_cert ? module.self_signed_cert.acm_certificate_arn : var.custom_cert_arn
      forward = {
        target_group_key = "appserver-blue"
      }
    }
  }

  target_groups = {
    appserver-blue = {
      name_prefix                       = "app-"
      protocol                          = "HTTP"
      port                              = 80
      deregistration_delay              = 5
      target_type                       = "instance"
      load_balancing_cross_zone_enabled = true

      # There's nothing to attach here in this definition.
      # The attachment happens in the ASG module above
      create_attachment = false
    }
  }

  tags = local.tags
}
