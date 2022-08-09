resource "aws_db_instance" "finances-rds" {
  identifier                  = "finances-db"
  engine                      = "postgres"
  engine_version              = "13.3"
  allocated_storage           = 10
  max_allocated_storage       = 20
  instance_class              = "db.t3.micro"
  username                    = "BA6MygjngR8p7Xfz"
  password                    = "b8s6PjHrk68dko4P"
  db_name                     = "finances"
  skip_final_snapshot         = true
  allow_major_version_upgrade = "true"
}