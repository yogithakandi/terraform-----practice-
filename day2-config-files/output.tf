output "publicip" {
    value = aws_instance.name.public_ip
  
}

output "az" {
    value = aws_instance.name.availability_zone
  
}

output "privateip" {
    value = aws_instance.name.private_ip
  
}