output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = try(aws_acm_certificate.this[0].arn, aws_acm_certificate.this[0].arn, "")
}