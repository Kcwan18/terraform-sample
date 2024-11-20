# Generate SSH key pair
resource "tls_private_key" "outline_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "outline_key_pair" {
  key_name   = "outline-key"
  public_key = tls_private_key.outline_key.public_key_openssh
}

# Save private key to local file
resource "local_file" "outline_private_key" {
  content  = tls_private_key.outline_key.private_key_pem
  filename = "ssh-key/outline-key.pem"

  # Set file permissions to be readable only by the owner
  file_permission = "400"
}

# Security group for SSH access
resource "aws_security_group" "outline_sg" {
  name        = "outline-sg"
  description = "Security group for Outline instance"
  vpc_id      = aws_vpc.outline_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outline management port"
  }


  ingress {
    from_port   = 31016
    to_port     = 31016
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outline access key port (UDP)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "outline-sg"
  }
}


# EC2 Instance
resource "aws_instance" "outline_instance" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.outline_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.outline_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              
              # Function to send Slack notification
              send_slack_notification() {
                message=$1
                curl -X POST -H 'Content-type: application/json' \
                  --data "$message" ${var.slack_webhook_url}
              }

              send_slack_notification "🚀 Starting Outline server installation..."

              # Install required packages
              dnf install wget jq awscli docker -y
              
              # Run Outline installation
              OUTLINE_CONFIG=$(bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)")
              
              # Extract and save the API configuration
              echo "$OUTLINE_CONFIG" | grep -o '{.*}' > /home/ec2-user/outline-config.json
              chown ec2-user:ec2-user /home/ec2-user/outline-config.json

              # Check if config file is not empty
              if [ -s /home/ec2-user/outline-config.json ]; then
                CONFIG_JSON=$(cat /home/ec2-user/outline-config.json)
                jsonvariable="{'text':'✅ Outline server installation successful! Copy below key to your outline manager :point_down::point_down: \n $CONFIG_JSON'}"
                send_slack_notification "$jsonvariable"
              else
                error_msg=$(journalctl -u outline-server | tail -n 5)
                jsonvariable="{'text':'❌ Outline server installation failed. Last logs:\n$error_msg'}"
                send_slack_notification "$jsonvariable"
                exit 1
              fi
              EOF

  tags = {
    Name = "outline-instance"
  }

  # Add IAM role for SNS publish permissions
  iam_instance_profile = aws_iam_instance_profile.outline_instance_profile.name
}

# Create IAM role and policy for EC2 
resource "aws_iam_role" "outline_instance_role" {
  name = "outline-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_instance_profile" "outline_instance_profile" {
  name = "outline-instance-profile"
  role = aws_iam_role.outline_instance_role.name
}
