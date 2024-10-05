variable "name" {
  description = "The name of the resource"
  type        = string
  default     = "mybank"
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
