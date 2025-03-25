output "alb_dns_name" {
  description = "ALB public DNS"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = module.rds.rds_endpoint
}
