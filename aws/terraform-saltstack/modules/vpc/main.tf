variable "vpc_cidr_block" {
	description = "CIDR block of the VPC"
}

variable "public_subnet_cidr_block" {
	description = "CIDR block of the public subnet"
}

data "aws_availability_zones" "available" {
	state = "available"
}

resource "aws_vpc" "salt-iac_vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_hostnames = true

	tags = {
		Name = "salt-iac_vpc"
	}
}

resource "aws_internet_gateway" "salt-iac_igw" {
	vpc_id = aws_vpc.salt-iac_vpc.id

	tags = {
		Name = "salt-iac_igw"
	}
}

resource "aws_subnet" "salt-iac_public_subnet" {
	vpc_id = aws_vpc.salt-iac_vpc.id
	cidr_block = var.public_subnet_cidr_block
	availability_zone = data.aws_availability_zones.available.names[0]

	tags = {
		Name = "salt-iac_public_subnet_1"
	}
}

resource "aws_route_table" "salt-iac_public_rt" {
	vpc_id = aws_vpc.salt-iac_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.salt-iac_igw.id
	}
}

resource "aws_route_table_association" "public" {
	route_table_id = aws_route_table.salt-iac_public_rt.id
	subnet_id = aws_subnet.salt-iac_public_subnet.id
}
