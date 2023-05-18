provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "JenkinsVCP" {
  cidr_block = "192.0.0.0/16"
}

resource "aws_subnet" "JenkinsVCP_subnet" {
  vpc_id            = aws_vpc.JenkinsVCP_vpc.id
  cidr_block        = "192.0.0.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_security_group" "Jenkins_sg" {
  name        = "my-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.JenkinsVCP_vpc.id

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
}
resource "aws_internet_gateway" "Jenkin-NAT" {
  vpc_id = aws_vpc.Jenkins-NAT.id
}
resource "aws_instance" "Jenkins" {
  ami                    = "ami-083eed19fc801d7a4"
  instance_type          = "t2.micro"
  key_name               = "lab6"
  subnet_id              = aws_subnet.custom_subnet.id
  vpc_security_group_ids = [aws_security_group.custom_sg.id]
}


# resource block for eip #
resource "aws_eip" "myeip" {
  vpc = true
}

# resource block for ec2 and eip association #
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Jenkins.id
  allocation_id = aws_eip.myeip.id
}

resource "aws_internet_gateway" "Jenkins" {
  vpc_id = aws_vpc.Jenkins.id
}

output "instance_public_ip" {
  value       = aws_instance.Jenkins.public_ip
  description = "The public IP address of the EC2 instance"
}
