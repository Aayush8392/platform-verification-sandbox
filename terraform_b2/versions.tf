terraform {
  required_version = ">= 1.13"

  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.14"
    }
  }

  # Same private B2 state bucket as C3, separate state file.
  backend "s3" {
    key                         = "b2-provider-test/terraform.tfstate"
    region                      = "eu-central-003"
    use_path_style              = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}

provider "b2" {}
