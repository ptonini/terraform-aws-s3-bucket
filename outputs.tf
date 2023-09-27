output "this" {
  value = aws_s3_bucket.this
}

output "access_policy_statements" {
  value = local.access_policy_statements
}

output "policy_arn" {
  value = try(module.policy[0].this["arn"], null)
}