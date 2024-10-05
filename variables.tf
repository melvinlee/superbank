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

variable "domain_name" {
  description = "The domain name for the ALB."
  type        = string
  default     = "powerbank.com"
}

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

variable "create_jumphost" {
  description = "Create a jumphost instance"
  type        = bool
  default     = false

}
