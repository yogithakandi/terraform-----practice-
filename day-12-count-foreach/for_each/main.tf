variable "env" {
    type = list(string)
    default = [ "yogitha","ammu","yogitha"]
  
}

resource "aws_instance" "name" {
    ami = "ami-0cae6d6fe6048ca2c"
    instance_type = "t3.micro"
    for_each = toset(var.env) 
    # tags = {
    #   Name = "dev"
    # }
  tags = {
      Name = each.value
    }
}