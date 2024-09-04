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
