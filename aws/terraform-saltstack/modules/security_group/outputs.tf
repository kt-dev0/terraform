output "sg_id" {
   description = "The ID of the security group"
   value = aws_security_group.salt-iac_salt_sg.id
}