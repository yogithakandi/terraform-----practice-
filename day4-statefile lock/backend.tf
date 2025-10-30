terraform {
  backend "s3" {
    bucket = "terraform--day3"
    key = "day4/terraform.tfstate"
    dynamodb_table = "terraform-4"
    encrypt = true
    region = "us-east-1"
  }
}