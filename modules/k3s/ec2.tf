
# Generate SSH key pair
resource "tls_private_key" "k3s_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "k3s_key_pair" {
  key_name   = "k3s-key"
  public_key = tls_private_key.k3s_key.public_key_openssh
}

# Save private key to local file
resource "local_file" "k3s_private_key" {
  content  = tls_private_key.k3s_key.private_key_pem
  filename = "ssh-key/k3s-key.pem"

  # Set file permissions to be readable only by the owner
  file_permission = "400"
}

# Security group for SSH access
resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Security group for K3s instance"
  vpc_id      = aws_vpc.k3s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "k3s-sg"
  }
}

# EC2 Instance
resource "aws_instance" "k3s_instance" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.k3s_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
              EOF

  tags = {
    Name = "k3s-instance"
  }
}
