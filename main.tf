#providing the version information of the Terraform 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}


provider "aws" {
  # Configuration options
  region  = "us-east-1"
 # profile = "default"
}

# creating VPC, Subnets, security Group  for medusa
resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "medusa_subnet_a" {
  vpc_id            = aws_vpc.medusa_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "medusa_subnet_b" {
  vpc_id            = aws_vpc.medusa_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "medusa_sg" {
  vpc_id = aws_vpc.medusa_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Internet Gateway
resource "aws_internet_gateway" "medusa_igw" {
  vpc_id = aws_vpc.medusa_vpc.id
}

# Route Table
resource "aws_route_table" "medusa_route_table" {
  vpc_id = aws_vpc.medusa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.medusa_igw.id
  }
}

# Route Table Associations
resource "aws_route_table_association" "medusa_subnet_a_association" {
  subnet_id      = aws_subnet.medusa_subnet_a.id
  route_table_id = aws_route_table.medusa_route_table.id
}

resource "aws_route_table_association" "medusa_subnet_b_association" {
  subnet_id      = aws_subnet.medusa_subnet_b.id
  route_table_id = aws_route_table.medusa_route_table.id
}
