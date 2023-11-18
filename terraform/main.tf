terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.24.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_passgen"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet_passgen"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig_passgen"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route_table_passgen"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_instance" "web" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet.id
  associate_public_ip_address = true
  key_name = aws_key_pair.key_rsa.key_name

  tags = {
    Name = "EC2-passgen"
  }
}

resource "aws_key_pair" "key_rsa" {
  key_name   = "chave-rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC59oeWFmnYUsww0d4kmTNryTSAGFEqzoaHPVgpjV89b3uLexd4JDWlGtDb9WFMAoY3d2WJySSCY21ZW68WEi7GoqfRd6C4ldfGRDVJZYhPSgFTSECtiJ5wgakpghkkUnhsvRZUfSf182nPQfB41v4Xiq1OqHMsoGwFccQiVJW8WhvFmvDDOEYIzVLvqYgBPJoXF1ZXbYU855kjjIe3Hv4PpabHh8Ts3pNvBZwHM3LSiklkV2G5Dao0xa3U5KygGCcAIMFhO9N4slqX0XRYB/bX+2URn0hN02x+MKOtt3ECx70hd3scc4izeMM2+C7sB7is35DdsJ6LXI88tHr8yFbdB5rmcecNLMpqpUFAdRDA6bYS8ga2rHDCHPbS+/V5GUHEC7lCktMSjTwz8muJlDLUg+LuyNWKW3o22vTVgKwQF2Qt6PrOGjQ2osKih4C86gWCrE1bJVJqvcVDn80mrOaNVfAxdsazgLWzEUI7itbTHHhH8ay08a1b7TyA9e8KtZk= alberto@Beto-Note"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}