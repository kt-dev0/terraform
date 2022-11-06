output "public_subnet_id" {
   description = "ID of the public subnet"
   value = aws_subnet.salt-iac_public_subnet.id
}

output "vpc_id" {
   description = "ID of the VPC"
   value = aws_vpc.salt-iac_vpc.id
}