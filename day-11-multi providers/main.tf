# EC2 instance in us-east-1 (default provider)
resource "aws_instance" "east_instance" {
  ami           = "ami-0cae6d6fe6048ca2c"   # Amazon Linux 2 in us-east-1
  instance_type = "t3.micro"

  tags = {
    Name = "dev"
  }
}

# EC2 instance in us-west-1 (Oregon, using profile aasha)
resource "aws_instance" "west_instance" {
  provider      = aws.oregon
  ami           = "ami-0cae6d6fe6048ca2c"   # Amazon Linux 2 in us-west-1
  instance_type = "t3.micro"

  tags = {
    Name = "test"
  }
}