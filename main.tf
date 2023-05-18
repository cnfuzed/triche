# Define provider and region
provider "aws" {
  region = "us-east-2"
}

# Create VPC
resource "aws_vpc" "automate_jenkins" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "Automate-Jenkins-vpc"
  }
}

# Create public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.automate_jenkins.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Automate-Jenkins-public-subnet-1"
  }
}

# Create public subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.automate_jenkins.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Automate-Jenkins-public-subnet-2"
  }
}

# Create private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.automate_jenkins.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Automate-Jenkins-private-subnet-1"
  }
}

# Create private subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.automate_jenkins.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Automate-Jenkins-private-subnet-2"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "automate_jenkins" {
  vpc_id = aws_vpc.automate_jenkins.id

  tags = {
    Name = "Automate-Jenkins-internet-gateway"
  }
}

# Create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.automate_jenkins.id

  tags = {
    Name = "Automate-Jenkins-public-route-table"
  }
}

# Associate route table with public subnet 1
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate route table with public subnet 2
resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create default route to the internet gateway in the public route table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.automate_jenkins.id
}

# Create route table for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.automate_jenkins.id

  tags = {
    Name = "Automate-Jenkins-private-route-table"
  }
}

# Associate route table with private subnet 1
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate route table with private subnet 2
resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create Amazon Linux 2 instance
resource "aws_instance" "automate_jenkins" {
  ami                    = "ami-0c94855ba95c71c99" # Replace with the desired Amazon Linux 2 AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.automate_jenkins_sg.id]

  tags = {
    Name = "Automate-Jenkins-instance"
  }
}

# Create security group for the instance allowing ports 22, 80, and 443
resource "aws_security_group" "automate_jenkins_sg" {
  vpc_id = aws_vpc.automate_jenkins.id

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

  ingress {
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
    Name = "Automate-Jenkins-security-group"
  }
}

# Allocate Elastic IP
resource "aws_eip" "automate_jenkins_eip" {
  vpc = true

  tags = {
    Name = "Automate-Jenkins-eip"
  }
}

# Associate Elastic IP with the instance
resource "aws_eip_association" "automate_jenkins_eip_association" {
  instance_id   = aws_instance.automate_jenkins.id
  allocation_id = aws_eip.automate_jenkins_eip.id
}

# Output the Elastic IP assigned to the instance
output "instance_eip" {
  value = aws_eip.automate_jenkins_eip.public_ip
}
