provider "aws" {
  region = "us-east-2"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-prod"
}

terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-st8"
    region         = "us-east-2"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running-prod"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"
  #password = data.aws_secretsmanager_secret_version.db_password.secret_string
  password            = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
  skip_final_snapshot = true
}
