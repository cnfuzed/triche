provider "aws" {
    region = "us-east-2"
  }
  
  resource "aws_vpc" "custom_vpc" {
    cidr_block = "10.0.0.0/16"
  }
  
  resource "aws_subnet" "custom_subnet" {
    vpc_id                  = aws_vpc.custom_vpc.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "us-east-2a"
  }
  
  resource "aws_security_group" "custom_sg" {
    name        = "my-ec2-sg"
    description = "Security group for EC2 instance"
    vpc_id      = aws_vpc.custom_vpc.id
  
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
  }
  
  resource "aws_instance" "example" {
    ami           = "ami-083eed19fc801d7a4"
    instance_type = "t2.micro"
    key_name      = "lab6"
    subnet_id     = aws_subnet.custom_subnet.id
    vpc_security_group_ids = [aws_security_group.custom_sg.id]
  }
  
  output "instance_public_ip" {
    value       = aws_instance.example.public_ip
    description = "The public IP address of the EC2 instance"
  }
