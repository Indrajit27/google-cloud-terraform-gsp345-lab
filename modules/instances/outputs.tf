output "instance_names" {
  description = "Names of the managed Compute Engine instances."
  value = [
    google_compute_instance.tf-instance-1.name,
    google_compute_instance.tf-instance-2.name
  ]
}
