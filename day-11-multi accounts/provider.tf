provider "aws" {
  region  = "us-east-1"
  profile = "ammulu"
}
provider "aws" {
    region = "us-west-2"
    alias = "oregon"
    profile = "ammu"
  
}