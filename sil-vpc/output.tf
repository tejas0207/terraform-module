output  "vpc_id" {
  value       = aws_vpc.vpc.id
}

output "subnet_public_1" {
  value       = aws_subnet.public_1.id
}

output "subnet_public_2" {
  value       = aws_subnet.public_2.id
}

output "sg-id" {
  value       = aws_security_group.allow_all.id
}



