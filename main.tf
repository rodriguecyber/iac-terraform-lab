terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"

  backend "s3" {}

 
}
provider "aws" {
  region = var.aws_region
}

# =====================
# VPC
# ======================

resource "aws_vpc" "lab_vpc"{
cidr_block =  var.aws_region_cidr
enable_dns_support = true
enable_dns_hostnames = true
tags = var.lab_vpc_tags
}

# ------------------------
# Public Subnet
# ------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# =====================
# Route table and Route
# ======================

 resource "aws_route_table" "lab_route_table" {
  vpc_id = aws_vpc.lab_vpc.id
  tags =var.lab_vpc_tags
  }

  resource "aws_route_table_association" "pubic_association" {
    subnet_id= aws_subnet.public_subnet.id
    route_table_id = aws_route_table.lab_route_table.id
  }

  # ------------------------
# Security Group
# ------------------------
resource "aws_security_group" "lab_sg" {
  name        = "lab-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP from anywhere"
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

  tags = {
    Name = "lab-sg"
  }
}

# ------------------------
# EC2 Instance
# ------------------------

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "lab_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}


resource "aws_instance" "lab_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "lab-ec2"
  }
}

