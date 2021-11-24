provider "aws" {
  region = "us-east-2"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage"
}

# Partial configuration. The other settings (e.g. bucket, region) will be passed
# in from a file via -backend-config arguments to "terraform init"
terraform {
  backend "s3" {
      key = "stage/data-stores/mysql/terraform.tfstate"
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running-stage"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "example_database"
  username = "admin"
  #password = data.aws_secretsmanager_secret_version.db_password.secret_string
  password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
  skip_final_snapshot = true
}