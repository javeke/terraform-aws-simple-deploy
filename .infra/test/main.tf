terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "iac_vpc" {
  cidr_block = "172.0.0.0/16"

  tags = {
    Name    = "iac_vpc"
    project = var.project_tag_name
  }
}

resource "aws_subnet" "iac_test_subnet" {
  vpc_id            = aws_vpc.iac_vpc.id
  cidr_block        = "172.0.0.0/24"
  availability_zone = var.availability_zone

  depends_on = [
    aws_internet_gateway.iac_test_igw
  ]

  tags = {
    Name    = "iac_test_subnet"
    project = var.project_tag_name
  }
}

resource "aws_internet_gateway" "iac_test_igw" {
  vpc_id = aws_vpc.iac_vpc.id

  tags = {
    Name    = "iac_test_igw"
    project = var.project_tag_name
  }
}

resource "aws_route_table" "iac_test_route_table" {
  vpc_id = aws_vpc.iac_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac_test_igw.id
  }

  tags = {
    Name    = "iac_test_route_table"
    project = var.project_tag_name
  }
}


resource "aws_route_table_association" "iac_test_route_table_assoc" {
  subnet_id      = aws_subnet.iac_test_subnet.id
  route_table_id = aws_route_table.iac_test_route_table.id
}

resource "aws_eip" "iac_test_web_server_public_ip" {
  vpc                       = true
  instance                  = aws_instance.iac_test_web_server.id
  associate_with_private_ip = "172.0.0.17"
  depends_on = [
    aws_internet_gateway.iac_test_igw
  ]

  tags = {
    Name    = "iac_test_web_server_public_ip"
    project = var.project_tag_name
  }
}

resource "aws_security_group" "iac_test_web_server_allow_web" {
  name        = "allow_web_traffic"
  description = "Allows Web Traffic"
  vpc_id      = aws_vpc.iac_vpc.id

  ingress {
    description = "Allow SSH to server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound https traffic"
    from_port   = 443
    to_port     = 443
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
    Name    = "iac_test_web_server_allow_web"
    project = var.project_tag_name
  }
}

resource "aws_instance" "iac_test_web_server" {
  ami                    = "ami-052efd3df9dad4825"
  availability_zone      = var.availability_zone
  instance_type          = "t2.micro"
  private_ip             = "172.0.0.17"
  subnet_id              = aws_subnet.iac_test_subnet.id
  vpc_security_group_ids = [aws_security_group.iac_test_web_server_allow_web.id]
  key_name               = "iac_test_key_pair"

  user_data = file("init.sh")

  tags = {
    Name    = "iac_test_web_server"
    project = var.project_tag_name
  }
}