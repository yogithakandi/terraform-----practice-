variable "ami_id" {
  description = "passing ami id "
  default = "ami-0bdd88bd06d16ba03"
  type = string
}
variable "instance_type" {
    description = "passing instance"
    default = "t3.micro"
    type =  string
}