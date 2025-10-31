provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

#######################
# 1. VPC
#######################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

#######################
# 2. Internet Gateway
#######################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

#######################
# 3. Public Subnet
#######################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

#######################
# 4. Private Subnet
#######################
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}

#######################
# 5. Public Route Table
#######################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

#######################
# 6. Public Subnet Association
#######################
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#######################
# 7. Elastic IP for NAT Gateway
#######################
resource "aws_eip" "nat_ip" {
   domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

#######################
# 8. NAT Gateway
#######################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gw"
  }
}

#######################
# 9. Private Route Table
#######################
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

#######################
# 10. Private Subnet Association
#######################
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

#######################
# 11. Security Group
#######################
resource "aws_security_group" "dev_sg" {
  name        = "dev-sg"
  description = "Allow SSH & HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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
    Name = "dev-sg"
  }
}

#######################
# 12. EC2 Instance in Public Subnet
#######################
resource "aws_instance" "public_server" {
  ami           = "ami-0bdd88bd06d16ba03" # Amazon Linux 2 (ap-south-1)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "terraform"

  vpc_security_group_ids = [aws_security_group.dev_sg.id]

  tags = {
    Name = "public-server"
  }
}

#######################
# 13. EC2 Instance in Private Subnet
#######################
resource "aws_instance" "private_server" {
  ami           = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = "terraform"

  vpc_security_group_ids = [aws_security_group.dev_sg.id]

  tags = {
    Name = "private-server"
  }
}
