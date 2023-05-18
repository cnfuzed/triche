provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-083eed19fc801d7a4"
  instance_type = "t2.nano"
}
