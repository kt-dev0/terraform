variable "vpc_id" {
   description = "ID of the VPC"
   type        = string
}

variable "my_ip" {
   description = "My IP address"
   type = string
}

resource "aws_security_group" "salt-iac_salt_sg" {
   name = "salt-iac_salt_sg"
   description = "Security group for salt server"
   vpc_id = var.vpc_id

   ingress {
      description = "Allow SSH from my computer"
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["${var.my_ip}/32"]
   }
   ingress {
      
      description = "Allow all TCP from my computer"
      from_port = "0"
      to_port = "65535"
      protocol = "tcp"
      self = "true"

   }

     ingress {
      
      description = "Allow incoming ICMP"
      from_port = -1
      to_port = -1
      protocol = "icmp"
      self = "true" 

   }

   egress {
      description = "Allow all outbound traffic"
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
      Name = "salt-iac_salt_sg"
   }
}