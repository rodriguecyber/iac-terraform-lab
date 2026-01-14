output "vpc_id" {
  value = aws_vpc.lab_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "ec2_public_ip" {
  value = aws_instance.lab_ec2.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.lab_ec2.id
}
