terraform {
  required_version = ">= 1.13"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.137"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }

  # State lives in a private Backblaze B2 bucket through its S3-compatible API.
  # The bucket name and keys are supplied at init time (never committed).
  backend "s3" {
    key                         = "sandbox/terraform.tfstate"
    region                      = "eu-central-003"
    use_path_style              = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}
