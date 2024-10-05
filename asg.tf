##################################################################
# Autoscaling group for app server
# This example creates an Auto Scaling Group for app servers. 
##################################################################

locals {

  user_data = <<-EOT
    #!/bin/bash
    
    yum update -y
    amazon-linux-extras install nginx1.12
    systemctl start nginx
  EOT
}

module "appserver_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0.0"

  # Autoscaling group
  name = "${local.environment}-appserver"

  vpc_zone_identifier     = module.vpc.private_subnets
  min_size                = var.asg_min_size
  max_size                = var.asg_max_size
  desired_capacity        = var.asg_desired_capacity
  default_instance_warmup = 300
  health_check_type       = "ELB"

  image_id           = data.aws_ami.amazon_linux.id
  instance_type      = var.app_instance_type
  user_data          = base64encode(local.user_data)
  capacity_rebalance = true

  security_groups = [module.asg_sg.security_group_id]

  #   iam_instance_profile_arn = aws_iam_instance_profile.ssm.arn

  traffic_source_attachments = {
    alb = {
      traffic_source_identifier = module.alb.target_groups["appserver-blue"].arn
      traffic_source_type       = "elbv2" # default
    }
  }

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  ebs_optimized     = true
  enable_monitoring = false


  instance_market_options = {
    market_type = "spot"
  }

  tags = local.tags

}

module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.environment}-${local.name}-sg"
  description = "A security group"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.tags
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
}
