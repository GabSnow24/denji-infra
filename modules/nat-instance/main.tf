terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "security_group"{
  source = "../sg"
  vpc_data = {
    id = var.vpc_data.id
  }
  nat = true
  environment = "Development"
}




