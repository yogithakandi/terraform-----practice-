terraform {
  backend "s3" {
    bucket = "terraform--day3"
    key = "day3/terraform.tfstate"
    region = "us-east-1"
  }
}