resource "aws_instance" "name" {
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    tags = {
        Name = "serverrr"
    }

}

resource "aws_vpc" "name" {
   cidr_block = "10.0.0.0/16"
   tags = {
     name = "target"
   }
}