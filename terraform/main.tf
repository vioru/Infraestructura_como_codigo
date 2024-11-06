terraform {
  required_providers {
    aws = {
      source = "./providers.tf"
    }
  }
}

# VPC
resource "aws_vpc" "prueba_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet Publica 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.prueba_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
}

# Subnet Publica 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.prueba_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
}

# Subnet Privada 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.prueba_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2a"
}

# Subnet Privada 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.prueba_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-2b"
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prueba_vpc.id
}

# Route Table para Subnet Pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prueba_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


# Instancia EC2 en Subnet Pública
resource "aws_instance" "web_instance_1" {
  ami           = "ami-0866a3c8686eaeeba" # ubuntu
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_instance" "web_instance_2" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_2.id
}
