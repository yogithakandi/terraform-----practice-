resource "aws_instance" "server" {
  ami           = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"

  lifecycle {
    reate_before_destroy = true
   
    }
}


#lifecycle {
  #ignore_changes = [tags, ]
#}
 
#lifecycle {
#prevent distroy = true
#}

