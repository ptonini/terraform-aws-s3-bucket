output "this" {
  value = aws_s3_bucket.this
}

output "access_policy_statements" {
  value = local.access_policy_statements
}

output "policy_arn" {
  value = try(module.policy[0].this["arn"], null)
}

output "role" {
  value = try(module.role[0].this, null)
  sensitive = true
}

output "vault_role_name" {
  value = try(module.role[0].vault_role_name, null)
  sensitive = true
}

output "vault_role_path" {
  value = try(module.role[0].vault_role_path, null)
  sensitive = true
}
