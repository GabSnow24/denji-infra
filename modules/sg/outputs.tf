output "nat_sg" {
  value       = aws_security_group.nat[0]
  description = "Nat SG"
  depends_on = [
    aws_security_group.nat
  ]
}


output "web_sg" {
  value       = aws_security_group.web[0]
  description = "Web SG"
  depends_on = [
    aws_security_group.web
  ]
}