terraform {
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "GrauTerraformLab"

  # workspaces {
  #   name = "terra-house-lab"
  #   }
  # }
#   cloud {
#     organization = "GrauTerraformLab"
#     workspaces {
#       name = "terra-house-lab"
#     }
#   }
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}