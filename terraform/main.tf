provider "aws" {
  region = var.region
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "vinod-web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    description = "HTTP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    set -e
    dnf update -y
    dnf install -y nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <html>
      <head><title>Vinod App</title></head>
      <body style="font-family: Arial; padding: 40px;">
        <h1>Hello All my name is vinod welcome to my world </h1>
      </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Name = "vinod-hello-ec2"
  }
}
