provider "aws" {
  region = "eu-west-1"
}

locals {
  environment = "test"
  label_order = ["name", "environment"]
}

module "s3_bucket" {
  source = "./../../"

  name            = "test-secure-bucket"
  environment     = local.environment
  label_order     = local.label_order
  s3_name         = "cdkc-test"
  acl             = "private"
  versioning      = true
  primary_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-56ef-78gh-90ij-klmnopqrstuv"
}