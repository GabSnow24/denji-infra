output "nat_instance" {
  value       = aws_instance.nat_instance
  description = "Nat Instance Values"
  depends_on = [
    aws_instance.nat_instance
  ]
}