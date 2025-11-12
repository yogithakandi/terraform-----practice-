resource "aws_instance" "name" {
  ami="ami-0cae6d6fe6048ca2c" 
  instance_type = "t3.micro"

}

resource "aws_s3_bucket" "name" {
    bucket = "multi account"
    provider = aws.oregon
  
}