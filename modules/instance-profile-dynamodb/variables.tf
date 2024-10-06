variable "create_iam_instance_profile" {
  description = "Create an IAM instance profile for the EC2 instances"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  type        = string
}

variable "aws_kms_key_arn" {
  description = "The ARN of the KMS key"
  type        = string
}
