# resource "aws_instance" "name" {
#     ami = "ami-0cae6d6fe6048ca2c"
#     instance_type = "t3.micro"
#     count = 2
#     # tags = {
#     #   Name = "ammu"
#     # }
#   tags = {
#       Name = "ammu-${count.index}"
#     }
# }

variable "env" {
    type = list(string)
    default = [ "yogitha","ammu"]
  
}

resource "aws_instance" "name" {
    ami = "ami-0cae6d6fe6048ca2c"
    instance_type = "t2.micro"
    count = length(var.env)
    # tags = {
    #   Name = "dev"
    # }
  tags = {
      Name = var.env[count.index]
    }
}