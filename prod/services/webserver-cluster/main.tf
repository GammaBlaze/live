terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-st8"
    key            = "prod/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "github.com/GammaBlaze/modules//services/webserver-cluster"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running-st8"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type      = "m4.large"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "terraform"
  }
}
