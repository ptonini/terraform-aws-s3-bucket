locals {
  access_policy_statements = [
    {
      Effect = "Allow"
      Action = ["s3:ListAllMyBuckets"]
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