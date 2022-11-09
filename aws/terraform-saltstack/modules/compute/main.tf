variable "security_group" {
   description = "The security groups assigned to the salt server"
}

variable "public_subnet" {
   description = "The public subnet IDs assigned to the salt server"
}

resource "aws_instance" "salt_server" {
   ami = "ami-09d3b3274b6c5d4aa"
   subnet_id = var.public_subnet
   instance_type = "t2.micro"
   private_ip = "10.10.1.234"
   vpc_security_group_ids = [var.security_group]
   key_name = aws_key_pair.salt-iac_kp.key_name
   user_data = "${file("${path.module}/scripts/install_salt_master.sh")}"

   tags = {
      Name = "aws-saltmaster"
   }
 }

resource "aws_key_pair" "salt-iac_kp" {
   key_name = "salt-iac_kp"
   public_key = file("${path.module}/salt-iac_kp.pub")
}

resource "aws_eip" "salt_eip" {
   instance = aws_instance.salt_server.id
   vpc      = true

   tags = {
      Name = "salt_eip"
   }
}

resource "aws_instance" "salt_minion" {
  depends_on = [aws_instance.salt_server]
  ami = "ami-09d3b3274b6c5d4aa"
  subnet_id = var.public_subnet
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.security_group]
  key_name = aws_key_pair.salt-iac_kp.key_name
  user_data = "${file("${path.module}/scripts/install_salt_minion.sh")}"
  count = 3

  tags = {
    Name = "aws-minion-${count.index}"
  }
}
resource "aws_eip" "minion_eip" {
  depends_on = [aws_instance.salt_server]
  instance = aws_instance.salt_minion[count.index].id
  vpc      = true
  count = 3

  tags = {
     Name = "minion_eip${count.index}"
}
}