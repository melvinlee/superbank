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

  userdata = templatefile("./user-data/bootstrap.sh.tpl", {
    image = "nginx:latest"
  })
}

module "appserver_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.3.0"

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
  user_data          = base64encode(local.userdata)
  capacity_rebalance = true

  security_groups = [module.asg_sg.security_group_id]

  iam_instance_profile_name = module.instance_profile_dynamodb.name
  #   iam_instance_profile_arn = aws_iam_instance_profile.ssm.arn

  traffic_source_attachments = {
    alb = {
      traffic_source_identifier = module.application_alb.target_groups["appserver-blue"].arn
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
  enable_monitoring = local.environment == "development" ? false : true

  # FinOps - Shutdown the development instances during the night and in the morning
  schedules = {
    night = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "0 20 * * 1-5" # Mon-Fri in the evening
      time_zone        = "Asia/Singapore"
    }

    morning = {
      min_size         = 0
      max_size         = 1
      desired_capacity = 1
      recurrence       = "0 8 * * 1-5" # Mon-Fri in the morning
      time_zone        = "Asia/Singapore"
    }
  }

  # Target scaling policy schedule based on Load Balancer Queue - ALBRequestCountPerTarget metric 
  scaling_policies = {
    request-count-per-target = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 60
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ALBRequestCountPerTarget"
          resource_label         = "${module.application_alb.arn_suffix}/${module.application_alb.target_groups["appserver-blue"].arn_suffix}"
        }
        target_value = 800
      }
    }
  }

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
      source_security_group_id = module.application_alb.security_group_id
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

