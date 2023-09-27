variable "name" {}

variable "force_destroy" {
  default = false
}

variable "object_ownership" {
  default = "ObjectWriter"
}

variable "acl" {
  default = "private"
}

variable "versioning" {
  default = "Suspended"
}

variable "bucket_policy_statements" {
  default = []
}

variable "server_side_encryption" {
  default = {
    kms_master_key_id = null
    sse_algorithm     = "AES256"
  }
}

variable "inventory" {
  default = false
}

variable "inventory_enabled" {
  default = true
}

variable "inventory_included_object_versions" {
  default = "All"
}

variable "inventory_schedule" {
  default = "Weekly"
}

variable "inventory_format" {
  default = "ORC"
}

variable "inventory_bucket_arn" {
  default = null
}

variable "create_policy" {
  default = false
}

variable "create_role" {
  default = false
}

variable "role_owner_arn" {
  default = null
}

variable "public_access_block" {
  default = false
}

variable "block_public_acls" {
  default = null
}

variable "block_public_policy" {
  default = null
}

variable "ignore_public_acls" {
  default = null
}

variable "restrict_public_buckets" {
  default = null
}