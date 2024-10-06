variable "create_certificate" {
  description = "Whether to create certificate"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The domain name for the ALB."
  type        = string
  default     = "powerbank.com"
}

variable "organization" {
  description = "The organization name for the certificate."
  type        = string
  default     = "myBankCo."
  
}