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
  endpoint = "http://localhost:4567/api"
  user_uuid = "e328f4ab-b99f-421c-84c9-4ccea042c7d1"
  token = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}
# module "terrahouse_aws"{
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   assets_path = var.assets_path
#   content_version = var.content_version
# }

resource "terratowns_home" "home" {
  name = "Assassins Creed Complete History"
  description = <<DESCRIPTION
Assasins Creed is set in a fictional history of real-world events, 
taking place primarily during the Third Crusade in the Holy Land in 1191.
From there it takes players on a journey through various historical periods and locations.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}