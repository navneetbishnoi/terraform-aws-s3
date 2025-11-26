provider "aws" {
  region = "eu-west-1"
}

locals {
  environment = "test11"
  label_order = ["name", "environment"]
}

module "logging_bucket" {
  source = "./../../"

  name            = "logging-s3-test"
  s3_name         = "zanq11-test"
  environment     = local.environment
  label_order     = local.label_order
  acl             = "log-delivery-write"
  primary_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-56ef-78gh-90ij-klmnopqrstuv"
}

module "s3_bucket" {
  source          = "./../../"
  name            = "test-logging-bucket"
  s3_name         = "wewrrt-test"
  environment     = local.environment
  label_order     = local.label_order
  versioning      = true
  acl             = "private"
  logging         = true
  target_bucket   = module.logging_bucket.id
  target_prefix   = "logs"
  depends_on      = [module.logging_bucket]
  primary_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-56ef-78gh-90ij-klmnopqrstuv"
}