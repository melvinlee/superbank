################################################################################
# DynamoDB Table with Server-Side Encryption
################################################################################

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 4.1.0"

  create_table = var.create_table

  name     = "AccountBalance"
  hash_key = "account_id"

  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = aws_kms_key.primary.arn

  read_capacity               = var.read_capacity
  write_capacity              = var.write_capacity
  billing_mode                = var.read_capacity > 0 || var.write_capacity > 0 ? "PROVISIONED" : "PAY_PER_REQUEST"
  autoscaling_enabled         = var.autoscaling_enabled
  deletion_protection_enabled = var.deletion_protection_enabled

  attributes = [
    {
      name = "account_id"
      type = "S"
    }
  ]

  tags = local.tags
}

resource "aws_kms_key" "primary" {
  description = "CMK for primary region"
  tags        = local.tags
}
