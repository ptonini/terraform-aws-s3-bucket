variable "name" {}

variable "force_destroy" {
  default = false
}

variable "object_ownership" {
  default = "BucketOwnerEnforced"
}

variable "acl" {
  default = "private"
}

variable "versioning" {
  default = "Enabled"
}

variable "create_policy" {
  default = false
}

variable "bucket_policy_statements" {
  default = []
}

variable "server_side_encryption" {
  type = object({
    kms_master_key_id = optional(string)
    sse_algorithm     = optional(string, "AES256")
  })
  default = {}
}

variable "inventory" {
  type = object({
    enabled                  = optional(bool, true)
    included_object_versions = optional(string, "All")
    schedule_frequency       = optional(string, "Weekly")
    bucket_arn               = string
    bucket_format            = optional(string, "ORC")
  })
  default = null
}

variable "public_access_block" {
  type = object({
    restrict_public_buckets = optional(bool, true)
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, false)
    ignore_public_acls      = optional(bool, true)
  })
  default = {}
}

variable "lifecycle_rules" {
  type = map(object({
    id              = string
    status          = string
    expiration_days = number
  }))
  default = null
}

variable "logging" {
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = null
}
