##################################################################
# Application Load Balancer (ALB)
# This module deploys an Application Load Balancer (ALB) in AWS and configures it to listen on port 80 and 443.
##################################################################

# data "aws_acm_certificate" "issued" {
#   domain   = var.domain_name
#   statuses = ["ISSUED"]
# }

module "alb" {
  source = "terraform-aws-modules/alb/aws"

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
      certificate_arn = aws_acm_certificate.cert.arn
      forward = {
        target_group_key = "instance"
      }
    }
  }

  target_groups = {
    instance = {
      name_prefix = "api"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      target_id   = ""
    }
  }
  
  tags = local.tags
}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket_prefix = "${local.name}-logs-"
  acl           = "log-delivery-write"

  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  tags = local.tags
}
