provider "aws" {
  region = "ap-south-1"
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support

  tags = {
      Name = var.tags
    }

}

#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-internet-gateway"
  }
}

#public subnets

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block = var.public1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public_1-${var.env}"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block = var.public2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public_2-${var.env}"
  }
}

# creating route table 

resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table-${var.env}"
  }
}

#route table association

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.route-public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.route-public.id
}


resource "aws_security_group" "allow_all" {
  name        = "${var.env}-sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "All trafic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-sg"
  }
}