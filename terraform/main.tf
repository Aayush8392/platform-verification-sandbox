provider "databricks" {} # host and token come from DATABRICKS_HOST / DATABRICKS_TOKEN

provider "github" {
  owner = var.github_owner # token comes from GITHUB_TOKEN
}

# ---------- Databricks: schema, volume and grants as code ----------
resource "databricks_schema" "tf_demo" {
  catalog_name = "workspace"
  name         = "tf_demo"
  comment      = "Created by Terraform (test C3)"
}

resource "databricks_volume" "tf_landing" {
  catalog_name = "workspace"
  schema_name  = databricks_schema.tf_demo.name
  name         = "tf_landing"
  volume_type  = "MANAGED"
  comment      = "Created by Terraform (test C3)"
}

resource "databricks_grants" "tf_demo_schema" {
  schema = "${databricks_schema.tf_demo.catalog_name}.${databricks_schema.tf_demo.name}"

  grant {
    principal  = var.analyst_email
    privileges = ["USE_SCHEMA", "SELECT"]
  }
}

# ---------- GitHub: a protected demo branch and an environment ----------
data "github_repository" "sandbox" {
  name = var.github_repo
}

resource "github_branch" "tf_demo" {
  repository    = data.github_repository.sandbox.name
  branch        = "tf-demo"
  source_branch = "main"
}

resource "github_branch_protection" "tf_demo" {
  repository_id  = data.github_repository.sandbox.node_id
  pattern        = github_branch.tf_demo.branch
  enforce_admins = false

  required_pull_request_reviews {
    required_approving_review_count = 0
  }
}

resource "github_repository_environment" "terraform_demo" {
  repository  = data.github_repository.sandbox.name
  environment = "terraform-demo"
}
