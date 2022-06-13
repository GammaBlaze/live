provider "aws" {
  region = "us-east-2"
}

module "users" {
  source = "github.com/GammaBlaze/modules//landing-zone/iam-user"

  for_each  = toset(var.user_names)
  user_name = each.key
}
