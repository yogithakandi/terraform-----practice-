provider "aws" {
  region = "us-east-1"  # change as needed
}

# Replace these with your actual VPC and subnet IDs
variable "vpc_id" {
  default = "vpc-0abcd1234efgh5678"
}

variable "subnet_ids" {
  type    = list(string)
  default = [
    "subnet-0abc12345def67890",  # subnet in AZ1
    "subnet-0def67890abc12345"   # subnet in AZ2
  ]
}


# Create DB Subnet Group
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "MySQL Subnet Group"
  }
}

# Create the RDS instance
resource "aws_db_instance" "mysql_rds" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "vaishu5050"
  db_name                 = "dev"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
}

# Execute SQL script from local machine
resource "null_resource" "local_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds]

  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -pvaishu5050 dev < test.sql"
  }

  triggers = {
    always_run = timestamp()
  }
}
