terraform {
  backend "s3" {
    bucket = "terraform--day3"
    key = "day2/terraform.tfstate"
    region = "us-east-1"
  }
}