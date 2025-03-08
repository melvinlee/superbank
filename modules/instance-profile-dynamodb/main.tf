##################################################################
#  IAM Instance Profile for EC2
##################################################################

locals {
  tags = var.tags
}

resource "aws_iam_role" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  name_prefix = "DynamoDBAccess"
  description = "IAM role for EC2 app instance"
  tags        = local.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "appserver-profile"
  role = aws_iam_role.this[0].name
  tags = local.tags
}

resource "aws_iam_role_policy" "kms_policy" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "KMSAccess"
  role = aws_iam_role.this[0].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "${var.aws_kms_key_arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "DynamoFullAccess"
  role = aws_iam_role.this[0].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAndDescribe",
            "Effect": "Allow",
            "Action": [
                "dynamodb:List*",
                "dynamodb:DescribeReservedCapacity*",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWrite*",
                "dynamodb:CreateTable",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": "${var.dynamodb_table_arn}"
        }
    ]
}
EOF
}
