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

}

module "terrahouse_aws"{
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}