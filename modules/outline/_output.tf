# Output VPC and Subnet Information
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.outline_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}


# Output the public DNS and IP of the EC2 instance
output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.outline_instance.public_dns
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance" 
  value       = aws_instance.outline_instance.public_ip
}
