terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
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

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws"{
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  assets_path = var.assets_path
  content_version = var.content_version
}

resource "terratowns_home" "home" {
  name = "The Witcher"
  description = <<DESCRIPTION
 The Witcher is a series of six fantasy novels and 15 short stories
  written by Polish author Andrzej Sapkowski. 
  The series revolves around the eponymous "witcher", Geralt of Rivia.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}