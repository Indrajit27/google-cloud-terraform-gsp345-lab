output "bucket_name" {
  description = "Name of the Google Cloud Storage bucket."
  value       = google_storage_bucket.tf_bucket.name
}
