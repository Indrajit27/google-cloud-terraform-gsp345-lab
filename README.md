# GSP345 – Automating Infrastructure on Google Cloud with Terraform

This repository documents my hands-on completion of the Google Cloud Skills Boost **GSP345: Automating Infrastructure on Google Cloud with Terraform** challenge lab.

## What this project demonstrates

- Terraform configuration split into reusable root and child modules
- Google Cloud provider configuration
- Importing existing Compute Engine VMs into Terraform state
- Google Cloud Storage bucket for Terraform remote state
- VM configuration updates using Terraform
- A custom VPC with two regional subnets using the Google Network module
- VM network-interface configuration
- An ingress firewall rule for HTTP (TCP port 80)

## Architecture

| Component | Configuration |
|---|---|
| Compute Engine VM 1 | `tf-instance-1`, `e2-standard-2`, `us-east4-c`, `subnet-01` |
| Compute Engine VM 2 | `tf-instance-2`, `e2-standard-2`, `us-east4-c`, `subnet-02` |
| VPC | `tf-vpc-140625`, global routing |
| Subnet 1 | `10.10.10.0/24`, `us-east4` |
| Subnet 2 | `10.10.20.0/24`, `us-east4` |
| Firewall | `tf-firewall`, ingress TCP port 80 from `0.0.0.0/0` |
| Terraform state | Google Cloud Storage backend |

## Repository structure

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── instances/
│   │   ├── instances.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage/
│       ├── storage.tf
│       ├── variables.tf
│       └── outputs.tf
└── .gitignore
```

## Prerequisites

- A Google Cloud project with billing enabled
- Terraform CLI
- Google Cloud CLI authenticated with access to the project
- Permissions to manage Compute Engine, VPC networking, firewall rules, and Cloud Storage

## Important: configure the remote-state bucket first

The GCS backend bucket must exist **before** running `terraform init`. In the lab, the bucket was created first and then the local Terraform state was migrated to it.

The backend block currently references the lab bucket `tf-bucket-947650`. Change that bucket name in `main.tf` if using a different project or environment. Create the bucket first, and do not commit Terraform state files.

## Initialize and validate

```bash
gcloud config set project YOUR_PROJECT_ID
gcloud auth application-default login

terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Review the plan carefully before applying:

```bash
terraform apply
```

## Importing pre-existing VMs

In the challenge lab, the first two Compute Engine instances already existed. They were imported into Terraform state before managing them through this configuration. For an existing environment, create matching resource blocks first, then import the instances using their full Terraform addresses, for example:

```bash
terraform import 'module.instances.google_compute_instance.tf-instance-1' 'projects/YOUR_PROJECT_ID/zones/us-east4-c/instances/tf-instance-1'
terraform import 'module.instances.google_compute_instance.tf-instance-2' 'projects/YOUR_PROJECT_ID/zones/us-east4-c/instances/tf-instance-2'
```

Only run these import commands when the instances exist and are not already tracked in the current Terraform state.

## Security and state-file handling

- Never commit `terraform.tfstate`, state backups, service-account keys, access tokens, or local credential files.
- The GCS bucket stores Terraform state and should have appropriately restricted IAM access.
- The firewall rule intentionally permits HTTP from all IPv4 addresses to match the challenge-lab requirement. For production, restrict source ranges where possible.
- The lab project, resource names, and bucket name are lab-specific examples; review them before reuse.

## Lab result

The configuration was applied successfully in the lab. The final firewall rule was verified with `gcloud compute firewall-rules describe tf-firewall`. The challenge-lab score should be confirmed separately in the Skills Boost progress checker.
