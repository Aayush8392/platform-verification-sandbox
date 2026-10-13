output "demo_schema" {
  value = "${databricks_schema.tf_demo.catalog_name}.${databricks_schema.tf_demo.name}"
}

output "protected_branch" {
  value = github_branch_protection.tf_demo.pattern
}
# rerun after token permission update
