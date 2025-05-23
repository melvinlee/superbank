##########################################################
# Environment configuration
##########################################################

variable "name" {
  description = "The name of the resource"
  type        = string
  default     = "mybank"
}

variable "cost_centre" {
  description = "The cost centre for the resources"
  type        = string
  default     = "888888"

}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  type        = string
  description = "The environment of the infrastructure"
  default     = "development"
}


##########################################################
# VPC configuration
##########################################################

variable "create_vpn_endpoints" {
  description = "Create VPC endpoints for S3 and DynamoDB"
  type        = bool
  default     = true

}

##########################################################
# Using self signed certificate for ALB
##########################################################

variable "create_self_signed_cert" {
  description = "Create a self-signed certificate"
  type        = bool
  default     = true

}

variable "domain_name" {
  description = "The domain name for the ALB."
  type        = string
  default     = "api.powerbank.com"
}

variable "organization" {
  description = "The organization name for the certificate."
  type        = string
  default     = "myBankCo."

}

##########################################################
# ALB configuration
##########################################################

variable "custom_cert_arn" {
  description = "The ARN of the custom certificate to use for the ALB."
  type        = string
  default     = ""

}

##########################################################
# Auto scaling group configuration
##########################################################

variable "app_instance_type" {
  description = "The instance type for the application servers."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "The minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

##########################################################
# Jump host configuration
##########################################################

variable "create_jumphost" {
  description = "Create a jumphost instance"
  type        = bool
  default     = false

}

variable "ingress_cidr_blocks" {
  description = "EC2 Instance Connect service IP addresses CIDR blocks"
  type        = string
  default     = "3.0.5.32/29"
}


##########################################################
# DynamoDB configuration
##########################################################

variable "create_table" {
  description = "Create a DynamoDB table for AccountBalance"
  type        = bool
  default     = true
  
}
variable "read_capacity" {
  description = "The read capacity for the DynamoDB table"
  type        = number
  default     = 0
}

variable "write_capacity" {
  description = "The write capacity for the DynamoDB table"
  type        = number
  default     = 0
}

variable "autoscaling_enabled" {
  description = "Enable autoscaling for the DynamoDB table"
  type        = bool
  default     = false
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection for the DynamoDB table"
  type        = bool
  default     = false   
}

##########################################################
# Instance Profile configuration
##########################################################

variable "create_iam_instance_profile" {
  description = "Create an IAM instance profile for the EC2 instances"
  type        = bool
  default     = true
}

##########################################################
# WAFv2 WebACL configuration
##########################################################

variable "create_waf" {
  description = "Create a WAFv2 WebACL"
  type        = bool
  default     = false
} 