# # 🏗️ Terraform-AWS-AWS S3

[![navneetbishnoi](https://img.shields.io/badge/Made%20by-navneetbishnoi-blue?style=flat-square&logo=terraform)](https://www.navneetbishnoi.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-1.13%2B-purple.svg?logo=terraform)](#)
[![CI](https://github.com/navneetbishnoi/terraform-aws-ec2/actions/workflows/ci.yml/badge.svg)](https://github.com/navneetbishnoi/terraform-aws-ec2/actions/workflows/ci.yml)

> 🌩️ **A production-grade, reusable AWS Ec2 module by [navneetbishnoi]**
> Designed for reliability, performance, and security — following AWS networking best practices.
---

## 🏢 About navneetbishnoi

**navneetbishnoi** delivers **Cloud & DevOps excellence** for modern teams:
- 🚀 **Infrastructure Automation** with Terraform, Ansible & Kubernetes
- 💰 **Cost Optimization** via scaling & right-sizing
- 🛡️ **Security & Compliance** baked into CI/CD pipelines
- ⚙️ **Fully Managed Operations** across AWS, Azure, and GCP


---
## 📘 Introduction

This Terraform module creates and manages **AWS S3 buckets** with full configuration flexibility.
It supports features like versioning, encryption, lifecycle rules, replication, and CORS — making it a complete and secure storage solution for your AWS environment.

---

## 🌟 Features

- ✅ Creates and manages **AWS S3 buckets** with customizable configurations
- ✅ Supports **versioning**, **logging**, and **encryption** options for enhanced data security
- ✅ Enables **object lifecycle management** for automatic transition and expiration policies
- ✅ Configurable **bucket policies**, **CORS rules**, and **public access settings**
- ✅ Seamless integration with other **AWS services** (e.g., CloudFront, KMS, IAM, Lambda)
- ✅ Supports **replication**, **access logging**, and **static website hosting**
- ✅ Compatible with **CloudWatch** and **AWS CloudTrail** for monitoring and auditing
- ✅ Automatically applies **tags and naming conventions** using the **Labels module**
- ✅ Fully compatible with other **navneetbishnoi Terraform modules**

---

## ⚙️ Usage Example
## Example: Default

```hcl
module "s3_bucket" {
  source      = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
  name        = "test-secure-bucket"
  environment = local.environment
  label_order = local.label_order
  s3_name     = "cdkc"
  acl         = "private"
  versioning  = true
}
```

## Example: s3 complete
```hcl
module "s3_bucket" {
  source      = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
  name        = "arcx-13"
  environment = local.environment
  label_order = local.label_order
  s3_name     = "sedfdrg"

  acceleration_status = true
  request_payer       = "BucketOwner"
  object_lock_enabled = true

  logging       = true
  target_bucket = module.logging_bucket.id
  target_prefix = "logs"

  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn

  object_lock_configuration = {
    mode  = "GOVERNANCE"
    days  = 366
    years = null
  }

  versioning    = true
  vpc_endpoints = [
    {
      endpoint_count = 1
      vpc_id         = module.vpc.vpc_id
      service_type   = "Interface"
      subnet_ids     = module.subnets.private_subnet_id
    },
    {
      endpoint_count = 2
      vpc_id         = module.vpc.vpc_id
      service_type   = "Gateway"
    }
  ]

  intelligent_tiering = {
    general = {
      status = "Enabled"
      filter = {
        prefix = "/"
        tags = {
          Environment = "dev"
        }
      }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 180
        }
      }
    },
    documents = {
      status = false
      filter = {
        prefix = "documents/"
      }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 125
        }
        DEEP_ARCHIVE_ACCESS = {
          days = 200
        }
      }
    }
  }

  metric_configuration = [
    {
      name = "documents"
      filter = {
        prefix = "documents/"
        tags = {
          priority = "high"
        }
      }
    },
    {
      name = "other"
      filter = {
        tags = {
          production = "true"
        }
      }
    },
    {
      name = "all"
    }
  ]


  cors_rule = [{
    allowed_headers = ["*"],
    allowed_methods = ["PUT", "POST"],
    allowed_origins = ["https://s3-website-test.hashicorp.com"],
    expose_headers  = ["ETag"],
    max_age_seconds = 3000
  }]


  grants = [
    {
      id          = null
      type        = "Group"
      permissions = ["READ", "WRITE"]
      uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    },
  ]
  owner_id = data.aws_canonical_user_id.current.id


  enable_lifecycle_configuration_rules = true
  lifecycle_configuration_rules = [
    {
      id                                             = "log"
      prefix                                         = null
      enabled                                        = true
      tags                                           = { "temp" : "true" }
      enable_glacier_transition                      = false
      enable_deeparchive_transition                  = false
      enable_standard_ia_transition                  = false
      enable_current_object_expiration               = true
      enable_noncurrent_version_expiration           = true
      abort_incomplete_multipart_upload_days         = null
      noncurrent_version_glacier_transition_days     = 0
      noncurrent_version_deeparchive_transition_days = 0
      noncurrent_version_expiration_days             = 30
      standard_transition_days                       = 0
      glacier_transition_days                        = 0
      deeparchive_transition_days                    = 0
      storage_class                                  = "GLACIER"
      expiration_days                                = 365
    },
    {
      id                                             = "log1"
      prefix                                         = null
      enabled                                        = true
      tags                                           = {}
      enable_glacier_transition                      = false
      enable_deeparchive_transition                  = false
      enable_standard_ia_transition                  = false
      enable_current_object_expiration               = true
      enable_noncurrent_version_expiration           = true
      abort_incomplete_multipart_upload_days         = 1
      noncurrent_version_glacier_transition_days     = 0
      noncurrent_version_deeparchive_transition_days = 0
      storage_class                                  = "DEEP_ARCHIVE"
      noncurrent_version_expiration_days             = 30
      standard_transition_days                       = 0
      glacier_transition_days                        = 0
      deeparchive_transition_days                    = 0
      expiration_days                                = 365
    }
  ]


  website = {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = [{
      condition = {
        key_prefix_equals = "docs/"
      },
      redirect = {
        replace_key_prefix_with = "documents/"
      }
    }, {
      condition = {
        http_error_code_returned_equals = 404
        key_prefix_equals               = "archive/"
      },
      redirect = {
        host_name          = "archive.myhost.com"
        http_redirect_code = 301
        protocol           = "https"
        replace_key_with   = "not_found.html"
      }
    }]
  }
}
```

## Example: s3-with-core-rule

```hcl
module "s3_bucket" {
  source      = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
  name        = "test-secure-bucket"
  environment = local.environment
  label_order = local.label_order
  s3_name     = "sdfdfg"
  versioning  = true

  acl = "private"
  cors_rule = [{
    allowed_headers = ["*"],
    allowed_methods = ["PUT", "POST"],
    allowed_origins = ["https://s3-website-test.hashicorp.com"],
    expose_headers  = ["ETag"],
    max_age_seconds = 3000
  }]
}
```

## Example: s3-with-encryption

```hcl
module "s3_bucket" {
  source      = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
  name        = "test-encryption-bucket"
  s3_name     = "dmzx"
  environment = local.environment
  label_order = local.label_order

  acl                           = "private"
  enable_server_side_encryption = true
  versioning                    = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn
}
```
## Example: s3-with-logging

```hcl
module "s3_bucket" {
source        = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
name          = "test-logging-bucket"
s3_name       = "wewrrt"
environment   = local.environment
label_order   = local.label_order
versioning    = true
acl           = "private"
logging       = true
target_bucket = module.logging_bucket.id
target_prefix = "logs"
depends_on    = [module.logging_bucket]
}
```
## Example: s3-with-logging-encryption

```hcl
module "s3_bucket" {
  source      = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
  name        = "test-logging-encryption-bucket"
  s3_name     = "aqua"
  environment = local.environment
  label_order = local.label_order

  versioning                    = true
  acl                           = "private"
  enable_server_side_encryption = true
  enable_kms                    = true
  kms_master_key_id             = module.kms_key.key_arn
  logging                       = true
  target_bucket                 = module.logging_bucket.id
  target_prefix                 = "logs"
  depends_on                    = [module.logging_bucket]
}
```

## Example: s3-with-repliccation

```hcl
module "s3_bucket" {
  source      = "git::https://github.com/navneetbishnoi/terraform-aws-s3.git?ref=v1.0.0"
  name        = "test-s3"
  s3_name     = "poxord"
  environment = local.environment
  label_order = local.label_order

  acl = "private"
  replication_configuration = {
    role       = aws_iam_role.replication.arn
    versioning = true

    rules = [
      {
        id                        = "something-with-kms-and-filter"
        status                    = true
        priority                  = 10
        delete_marker_replication = false
        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }
        filter = {
          prefix = "one"
          tags = {
            ReplicateMe = "Yes"
          }
        }
        destination = {
          bucket             = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class      = "STANDARD"
          replica_kms_key_id = aws_kms_key.replica.arn
          account_id         = data.aws_caller_identity.current.account_id
          access_control_translation = {
            owner = "Destination"
          }
          replication_time = {
            status  = "Enabled"
            minutes = 15
          }
          metrics = {
            status  = "Enabled"
            minutes = 15
          }
        }
      },
      {
        id                        = "something-with-filter"
        priority                  = 20
        delete_marker_replication = false
        filter = {
          prefix = "two"
          tags = {
            ReplicateMe = "Yes"
          }
        }
        destination = {
          bucket        = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class = "STANDARD"
        }
      },
      {
        id                        = "everything-with-filter"
        status                    = "Enabled"
        priority                  = 30
        delete_marker_replication = true
        1 = {
          prefix = ""
        }
        destination = {
          bucket        = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class = "STANDARD"
        }
      },
      {
        id                        = "everything-without-filters"
        status                    = "Enabled"
        delete_marker_replication = true
        destination = {
          bucket        = "arn:aws:s3:::${module.replica_bucket.id}"
          storage_class = "STANDARD"
        }
      },
    ]
  }
}
```
### 🔐 Outputs (AWS S3 Module)

| Name            | Description                                                                 |
|-----------------|------------------------------------------------------------------------------|
| `bucket_id`     | The unique identifier (ID) of the created **S3 bucket**.                    |
| `bucket_arn`    | The ARN (Amazon Resource Name) of the created **S3 bucket**.                |
| `bucket_name`   | The **name** of the S3 bucket.                                              |
| `region`        | The **AWS region** where the S3 bucket is created.                          |
| `hosted_zone_id`| The **Route53 hosted zone ID** for the bucket (useful for website hosting). |
| `domain_name`   | The **bucket domain name** (e.g., `my-bucket.s3.amazonaws.com`).             |
| `website_endpoint` | The **website endpoint** if static website hosting is enabled.            |
| `tags`          | A mapping of **tags** assigned to the S3 bucket resources.                  |


### ☁️ Tag Normalization Rules (AWS)

| Cloud | Case      | Allowed Characters | Example                            |
|--------|-----------|------------------|------------------------------------|
| **AWS** | TitleCase | Any              | `Name`, `Environment`, `CostCenter` |

---

### 💙 Maintained by [navneetbishnoi](https://www.navneetbishnoi.com)
> navneetbishnoi — Simplifying Cloud, Securing Scale.
