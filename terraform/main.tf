provider "aws" {
  region = "us-east-1"
  profile = "pruebas"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "Llave SSH"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-security-group"
  description = "Permitir acceso SSH"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    description = "HTTP"
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

resource "aws_instance" "vm" {
  ami                    = "ami-020cba7c55df1f615" 
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "TerraformVM"
  }
}
