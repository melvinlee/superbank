output "name" {
  description = "The name of the IAM instance profile"
  value       = aws_iam_instance_profile.this[0].name
}
