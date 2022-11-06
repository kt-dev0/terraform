output "public_ip" {
   description = "The public IP address of the salt master"
   value = aws_eip.salt_eip.public_ip
}