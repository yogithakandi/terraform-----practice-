resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "devvvvvvvvvv"
    }
  
}

resource "aws_instance" "name" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    tags = {
      name = "terraform"
    }
}

resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
