#####################################
# DB Subnet Group
#####################################
resource "aws_db_subnet_group" "subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [
    "subnet-03d249b8a08b9a35b",
    "subnet-0557dad1f21888d16"
  ]

  tags = {
    Name = "DB Subnet Group"
  }
}

#####################################
# IAM Role for RDS Enhanced Monitoring
#####################################
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role-terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

#####################################
# ✅ PRIMARY (MASTER) RDS INSTANCE
#####################################
resource "aws_db_instance" "primary" {
  identifier           = "my-primary-db"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "Cloud123"
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name

  # Backups required for replication
  backup_retention_period = 7

  # Enhanced Monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # Free tier settings
  performance_insights_enabled = false
  skip_final_snapshot = true
}

#####################################
# ✅ READ REPLICA
#####################################
resource "aws_db_instance" "replica" {
  identifier           = "my-read-replica"
  instance_class       = "db.t3.micro"

  # MUST reference PRIMARY DB
  replicate_source_db  = aws_db_instance.primary.arn

  # Same subnet group
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name

  skip_final_snapshot = true
}

#####################################
# Outputs
#####################################
output "primary_db_endpoint" {
  value = aws_db_instance.primary.endpoint
}

output "replica_db_endpoint" {
  value = aws_db_instance.replica.endpoint
}
