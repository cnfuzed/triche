# Define provider and region
provider "aws" {
  region = "us-east-2"
}

# Create VPC
resource "aws_vpc" "automate" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "automate-vpc"
  }
}

# Create public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.automate.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "automate-public-subnet-1"
  }
}

# Create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.automate.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "automate-public-subnet-2"
  }
}

# Create private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.automate.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "automate-private-subnet-1"
  }
}

# Create private subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.automate.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "automate-private-subnet-2"
  }
}

# Create NAT gateway
resource "aws_nat_gateway" "automate" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

# Create Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "automate-nat-eip"
  }
}

# Launch Amazon Linux 2 instance
resource "aws_instance" "automate" {
  ami           = "ami-0c94855ba95c71c99" # Replace with the desired Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "automate-instance"
  }
}

# Associate public EIP with the instance
resource "aws_eip_association" "automate" {
  instance_id   = aws_instance.automate.id
  allocation_id = aws_eip.instance_eip.id
}

# Create Elastic IP for the instance
resource "aws_eip" "instance_eip" {
  vpc = true

  tags = {
    Name = "automate-instance-eip"
  }
}

# Output the EIP assigned to the instance
output "instance_eip" {
  value = aws_eip.instance_eip.public_ip
}

