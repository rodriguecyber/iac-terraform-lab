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

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.lab_gw.id
}

  }

  resource "aws_route_table_association" "pubic_association" {
    subnet_id= aws_subnet.public_subnet.id
    route_table_id = aws_route_table.lab_route_table.id
  }

  # =====================
# Internet Gateway  
# ====================


resource "aws_internet_gateway" "lab_gw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "main"
  }
}

  # ------------------------
# Security Group
# ------------------------
resource "aws_security_group" "lab_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.lab_sg.id
  cidr_ipv4         = aws_vpc.lab_vpc.cidr_block
  from_port         = 20
  ip_protocol       = "tcp"
  to_port           = 20
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.lab_sg.id
  cidr_ipv4         = aws_vpc.lab_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# ------------------------
# EC2 Instance
# ------------------------

resource "aws_key_pair" "lab_key" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "lab_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.lab_sg.id]
  key_name                    = aws_key_pair.lab_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "lab-ec2"
  }
}

