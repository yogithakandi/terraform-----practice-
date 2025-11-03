module "name" {
  source = "../day-7-modules-terraform"
  ami_id = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"
}