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
  cloud {
    organization = "GrauTerraformLab"
    workspaces {
      name = "terra-house-lab"
    }
  }

}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_the_witcher_hosting"{
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.the_witcher.public_path
  content_version = var.the_witcher.content_version
}

resource "terratowns_home" "home_the_witcher" {
  name = "The Witcher"
  description = <<DESCRIPTION
 The Witcher is a series of six fantasy novels and 15 short stories
  written by Polish author Andrzej Sapkowski. 
  The series revolves around the eponymous "witcher", Geralt of Rivia.
DESCRIPTION
  domain_name = module.home_the_witcher_hosting.domain_name
  town = "gamers-grotto"
  content_version = var.the_witcher.content_version
}

module "home_assassins_creed_hosting"{
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.assassins_creed.public_path
  content_version = var.assassins_creed.content_version
}

resource "terratowns_home" "home_assassins_creed" {
  name = "Assassins Creed"
  description = <<DESCRIPTION
 The Game is set in a fictional history of real-world events, 
 taking place primarily during the Third Crusade in the Holy Land in 1191.
 In the game, a modern-day man named Desmond Miles who, through a machine called the Animus, 
 relives the genetic memories of his ancestor, Altaïr Ibn-La'Ahad.
DESCRIPTION
  domain_name = module.home_assassins_creed_hosting.domain_name
  town = "gamers-grotto"
  content_version = var.assassins_creed.content_version
}

module "home_venezuela_hosting"{
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.venezuela.public_path
  content_version = var.venezuela.content_version
}

resource "terratowns_home" "home_venezuela" {
  name = "Best Beaches in Venezuela"
  description = <<DESCRIPTION
 Welcome to our virtual journey through the stunning landscapes of Venezuela! 
 Explore the beauty of this South American paradise as we take you on a visual 
 tour of some of the best beaches the country has to offer.
DESCRIPTION
  domain_name = module.home_venezuela_hosting.domain_name
  town = "the-nomad-pad"
  content_version = var.venezuela.content_version
}