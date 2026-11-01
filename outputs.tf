output "storage_bucket_name" {
  description = "Name of the Terraform lab storage bucket."
  value       = module.storage.bucket_name
}

output "vpc_name" {
  description = "Name of the custom VPC."
  value       = "tf-vpc-140625"
}
