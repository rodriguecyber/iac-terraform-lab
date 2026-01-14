variable "aws_region" {
    type = string
    description = "The AWS region to deploy resources in"
    default = "eu-north-1"

  
}

variable "aws_region_cidr" {
    type = string
    description = "The CIDR block for the VPC"
    default = "10.0.0.0/16"
}

variable "lab_vpc_tags" {
    type = map(string)
    description = "Tags to apply to the VPC"
    default = {
        Name        = "lab-vpc"
        Environment = "Development"
    }
}

variable "key_name" {
    type = string
    description = "The name of the SSH key pair"
    default = "lab-key-pair"
}
variable "ami_id" {
    type = string
    description = "The AMI ID for the EC2 instance"
    default = "ami-0683ee28af6610487" 
  
}
variable "instance_type" {
    type = string
    description = "The instance type for the EC2 instance"
    default = "t3.micro"
}
variable "my_ip" {
    type = string
    description = "Your IP address in CIDR notation"
    default = "0.0.0.0/0"
    }
variable "availability_zone" {
  type = string
  description = "The availability zone to deploy resources in"
  default = "eu-north-1a"
}
