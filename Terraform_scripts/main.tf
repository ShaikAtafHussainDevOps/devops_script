terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-terra-vpc1"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-terra-sybnet1"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-terraig"
  }
}
resource "aws_route_table" "test" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-terra-route1"
 }
}
resource "aws_route" "r" {
  route_table_id              = aws_route_table.test.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id      = aws_internet_gateway.gw.id
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.test.id
}

                                      
