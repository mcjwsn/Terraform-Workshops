# Konfiguracja dostawcy (AWS)
provider "aws" {
  region = "eu-west-1"  # Zmień na preferowany region
}

# Dane o aktualnie zalogowanym użytkowniku AWS
data "aws_caller_identity" "current" {}

# Tworzenie VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# Tworzenie podsieci
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "example-subnet"
  }
}

# Tworzenie grupy bezpieczeństwa
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "example-sg"
  }
}

# Tworzenie instancji EC2
resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 (zmień na aktualną AMI dla Twojego regionu)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  tags = {
    Name = "example-instance"
  }
}

# Wyświetlanie informacji wyjściowych
output "instance_public_ip" {
  value = aws_instance.example_instance.public_ip
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}