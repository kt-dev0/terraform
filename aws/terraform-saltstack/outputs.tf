output "public_ip" {
   description = "The public IP address of the Salt Master"
   value = module.ec2_instance.public_ip
}