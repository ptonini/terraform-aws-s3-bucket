locals {
  access_policy_statements = [
    {
      Effect   = "Allow"
      Action   = ["s3:ListAllMyBuckets"]
      Resource = ["arn:aws:s3:::*"]
    },
    {
      Effect = "Allow"
      Action = [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions"
      ]
      Resource = [aws_s3_bucket.this.arn]
    },
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ]
      Resource = ["${aws_s3_bucket.this.arn}/*"]
    }
  ]
}

resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy
  lifecycle {
    ignore_changes = [
      server_side_encryption_configuration,
      tags,
      all_tags
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = coalesce(var.block_public_acls, var.public_access_block)
  block_public_policy     = coalesce(var.block_public_policy, var.public_access_block)
  ignore_public_acls      = coalesce(var.ignore_public_acls, var.public_access_block)
  restrict_public_buckets = coalesce(var.restrict_public_buckets, var.public_access_block)
}

resource "aws_s3_bucket_acl" "this" {
  bucket     = aws_s3_bucket.this.id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.server_side_encryption.kms_master_key_id
      sse_algorithm     = var.server_side_encryption.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(var.bucket_policy_statements, [
      {
        Principal : "*"
        Effect : "Deny"
        Action : ["s3:*"]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"
        ]
        Condition : { Bool : { "aws:SecureTransport" : "false" } }
      }
    ])
  })
}

resource "aws_s3_bucket_inventory" "this" {
  count                    = var.inventory ? 1 : 0
  bucket                   = aws_s3_bucket.this.id
  name                     = aws_s3_bucket.this.bucket
  enabled                  = var.inventory_enabled
  included_object_versions = var.inventory_included_object_versions
  schedule {
    frequency = var.inventory_schedule
  }
  destination {
    bucket {
      format     = var.inventory_format
      bucket_arn = var.inventory_bucket_arn
    }
  }
}

module "policy" {
  source  = "ptonini/iam-policy/aws"
  version = "~> 1.0.0"
  count   = var.create_policy ? 1 : 0
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = local.access_policy_statements
  })
}

module "role" {
  source                = "ptonini/iam-role/aws"
  version               = "~> 1.0.0"
  count                 = var.create_role ? 1 : 0
  assume_role_principal = { AWS = var.role_owner_arn }
  policy_statements     = local.access_policy_statements
  vault_role            = var.vault_role
  vault_credential_type = var.vault_credential_type
  vault_backend         = var.vault_backend
}