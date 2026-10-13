resource "b2_bucket" "probe" {
  bucket_name = "off-tfprobe-aayush-8392"
  bucket_type = "allPrivate"

  lifecycle_rules {
    file_name_prefix              = "raw/"
    days_from_uploading_to_hiding = 270
    days_from_hiding_to_deleting  = 1
  }

  lifecycle_rules {
    file_name_prefix              = "tmp/"
    days_from_uploading_to_hiding = 7
    days_from_hiding_to_deleting  = 1
  }
}

resource "b2_application_key" "upload_only" {
  key_name     = "tfprobe-upload-only"
  capabilities = ["writeFiles"]
  bucket_ids   = [b2_bucket.probe.bucket_id]
}

output "bucket_id" {
  value = b2_bucket.probe.bucket_id
}

output "upload_key_id" {
  value = b2_application_key.upload_only.application_key_id
}

output "upload_key_secret" {
  value     = b2_application_key.upload_only.application_key
  sensitive = true
}
