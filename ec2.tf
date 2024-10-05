################################################################################
# EC2 Module - with ignore AMI changes
################################################################################

locals {

  jumphost_user_data = <<-EOT
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker 
    yum install -y docker
    yum install -y ec2-instance-connect 
    service docker start
    usermod -a -G docker ec2-user
  EOT

}

module "ec2_jumphost" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.7.0"

  create = var.create_jumphost
  name   = "${local.environment}-jumphost"

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.jumphost_sg.security_group_id]
  associate_public_ip_address = true

  user_data_base64            = base64encode(local.jumphost_user_data)
  user_data_replace_on_change = true

  tags = local.tags
}


module "jumphost_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 5.0"

  create      = var.create_jumphost
  name        = "${local.environment}-jumphost-sg"
  description = "Security group with SSH ports open for jumphost"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.tags
}
