output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.home_the_witcher_hosting.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Wbsite Hosting Endpoint"
  value = module.home_the_witcher_hosting.website_endpoint
}

output "cloudfront_url" {
  description = "The CloudFront Distrib ution Domain Name"
  value = module.home_the_witcher_hosting.domain_name
}