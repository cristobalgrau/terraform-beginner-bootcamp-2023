## Terrahome AWS

```tf
module "home_the_witcher"{
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.the_witcher_public_path
  content_version = var.content_version
}
```

The public directory exoetcs the following:

- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories.