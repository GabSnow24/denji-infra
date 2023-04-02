output "tg_arn" {
  value       = aws_lb_target_group.api-tg.arn
  description = "TG ARN"
  depends_on = [
    aws_lb_target_group.api-tg
  ]
}


