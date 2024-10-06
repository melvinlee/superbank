output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.application_alb.dns_name  
}