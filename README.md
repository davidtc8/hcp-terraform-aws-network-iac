# AWS VPC Network Foundation — HCP Terraform (VCS-Driven GitOps)

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.16.0-7B42BC?logo=terraform)
![AWS Provider](https://img.shields.io/badge/AWS_Provider-~%3E6.31.0-FF9900?logo=amazon-aws)
![HCP Terraform](https://img.shields.io/badge/State_Backend-HCP_Terraform-000000?logo=hashicorp)
![Region](https://img.shields.io/badge/AWS_Region-us--east--2-232F3E)

Declarative Infrastructure as Code (IaC) provisioning a multi-Availability Zone **Amazon Virtual Private Cloud (VPC)** network foundation in `us-east-2` (Ohio).

This repository implements a **VCS-Driven GitOps workflow** integrated with **HCP Terraform (Terraform Cloud)**. Commits and Pull Requests targeting the `main` branch automatically trigger remote validation, state locking, execution planning, and infrastructure provisioning via webhook integration—eliminating manual CLI applies from local workstations.

---

## Architecture & GitOps Workflow

```text
[Developer Push / Pull Request]
              │
              ▼ (GitHub Webhook)
[HCP Terraform: davidtc8-hcp / hcp-demo]
  ├──► Pull Request: Executes Isolated Speculative Plan (Read-Only Check)
  └──► Push to `main`: Locks Remote State ──► Runs Plan ──► Policy Check & Apply
                                                                    │
                                                                    ▼ (Cloud Auth)
                                                      [AWS Cloud: us-east-2 (Ohio)]
                                                      ├── VPC: dev-main-vpc (10.0.0.0/16)
                                                      ├── Private Subnet (10.0.5.0/24 | us-east-2a)
                                                      └── Public Subnet  (10.0.100.0/24 | us-east-2b)
```

### Provisioned Infrastructure Resources
* **VPC (`aws_vpc.main`):** `10.0.0.0/16` primary IPv4 CIDR block configured with internal DNS resolution (`enable_dns_support = true`), DNS hostnames (`enable_dns_hostnames = true`), and environment resource tagging (`Environment = "development"`).
* **Private Subnet (`aws_subnet.private`):** `10.0.5.0/24` subnet in `us-east-2a` designed for isolated backend compute, relational databases, and private container nodes without public IPv4 exposure.
* **Public Subnet (`aws_subnet.public`):** `10.0.100.0/24` subnet in `us-east-2b` configured with automatic public IPv4 mapping (`map_public_ip_on_launch = true`) for ingress load balancers, NAT Gateways, and bastion hosts.
* **Remote State & Locking (`cloud` block):** Managed remotely in HCP Terraform (`davidtc8-hcp` organization / `hcp-demo` workspace) with encrypted state storage, concurrent run locking, and full audit history.

---

## Repository Structure

```text
.
├── main.tf                # Core AWS VPC, private subnet, and public subnet definitions
├── variables.tf           # Parameterized CIDR blocks and Availability Zone variables
├── versions.tf            # HCP Terraform cloud backend & AWS provider version constraints
├── .gitignore             # Excludes local .tfstate, .tfvars secrets, and provider binaries
└── README.md              # Architecture and GitOps operational documentation
```

---

## Prerequisites & Security Posture

* **Terraform Version:** `>= 1.16.0`
* **AWS Provider:** `hashicorp/aws` (`~> 6.31.0`)
* **Zero Secrets in Git:** Cloud credentials are never stored in version control. Authentication to AWS is handled at runtime inside the secured **HCP Terraform** workspace environment.

---

## Input Variables

| Variable Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| `vpc_cidr` | CIDR block for the VPC | `string` | `"10.0.0.0/16"` |
| `private_subnet_cidr` | CIDR block for the private subnet | `string` | `"10.0.5.0/24"` |
| `private_subnet_az` | Availability Zone for the private subnet | `string` | `"us-east-2a"` |
| `public_subnet_cidr` | CIDR block for the public subnet | `string` | `"10.0.100.0/24"` |
| `public_subnet_az` | Availability Zone for the public subnet | `string` | `"us-east-2b"` |

---

## VCS-Driven Deployment Lifecycle

Because the `hcp-demo` workspace is bound directly to this repository's `main` branch, infrastructure modifications follow a strict GitOps workflow:

### 1. Local Formatting & Static Validation
Before committing changes, verify HCL formatting and syntax locally without initializing the remote backend:

```bash
terraform fmt -check
terraform init -backend=false
terraform validate
```

### 2. Feature Branch & Speculative Plan (Pull Request)
Create a feature branch and open a Pull Request against `main`:

```bash
git checkout -b feat/network-updates
git add .
git commit -m "feat(vpc): update subnet configuration"
git push origin feat/network-updates
```
* **Automated Webhook Trigger:** HCP Terraform automatically detects the Pull Request, executes a non-destructive **Speculative Plan** in an ephemeral remote runner, and posts the execution summary back to the GitHub PR check.

### 3. Merge / Push to `main` (Production Run)
Merge the approved Pull Request or push directly to `main`:

```bash
git checkout main
git merge feat/network-updates
git push origin main
```
* **Automated Provisioning:** HCP Terraform locks the workspace state, generates the execution plan, and applies the validated changes to AWS (`us-east-2`).

---

## Author

**David Torres** — Cloud DevOps, SRE & Observability Engineer  
[LinkedIn](https://www.linkedin.com/in/david-tc) | [GitHub](https://github.com/davidtc8)