variable "analyst_email" {
  description = "Databricks user that receives read access to the demo schema (supplied via TF_VAR_analyst_email)."
  type        = string
  sensitive   = true
}

variable "github_owner" {
  type    = string
  default = "Aayush8392"
}

variable "github_repo" {
  type    = string
  default = "platform-verification-sandbox"
}
