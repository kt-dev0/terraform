terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "vm-web" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  count = 2

  tags = {
    Name = "aws-appserver-${count.index}"
  }
}