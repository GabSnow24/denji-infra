output "vpc_data" {
  value       = aws_vpc.main_vpc
  description = "VPC"
  depends_on = [
    aws_vpc.main_vpc
  ]
}

output "private_subnet_1_id" {
  value       = aws_subnet.private_subnet_1.id
  description = "Private Subnet 1 ID"
  depends_on = [
    aws_subnet.private_subnet_1
  ]
}

output "private_subnet_2_id" {
  value       = aws_subnet.private_subnet_2.id
  description = "Private Subnet 2 ID"
  depends_on = [
    aws_subnet.private_subnet_2
  ]
}

output "public_subnet_1_id" {
  value       = aws_subnet.public_subnet_1.id
  description = "Public Subnet 1 ID"
  depends_on = [
    aws_subnet.public_subnet_1
  ]
}

output "public_subnet_2_id" {
  value       = aws_subnet.public_subnet_2.id
  description = "Public Subnet 2 ID"
  depends_on = [
    aws_subnet.public_subnet_2
  ]
}


