# AWS VPC Network Foundation — HCP Terraform (IaC)

Declarative Infrastructure as Code (IaC) provisioning a multi-Availability Zone **Amazon Virtual Private Cloud (VPC)** network topology in `us-east-2` (Ohio), with remote state management, state locking, and execution governed via **HCP Terraform (Terraform Cloud)**.

---

## Architecture Overview

This configuration provisions an isolated foundational network layer designed for cloud-native compute (EC2/EKS) and data workloads:

* **VPC (`aws_vpc.main`):** `10.0.0.0/16` CIDR block with internal DNS support (`enable_dns_support = true`) and DNS hostnames (`enable_dns_hostnames = true`) enabled.
* **Private Subnet (`aws_subnet.private`):** `10.0.5.0/24` deployed in `us-east-2a` for internal backend services, databases, and private compute nodes (no public IP auto-assignment).
* **Public Subnet (`aws_subnet.public`):** `10.0.100.0/24` deployed in `us-east-2b` with automatic public IPv4 mapping (`map_public_ip_on_launch = true`) for ingress resources, bastion hosts, or NAT Gateways.
* **Remote State & Governance:** Integrated with **HCP Terraform** (`davidtc8-hcp` organization) to enforce encrypted remote state storage, state locking, and auditable execution runs.

---

## Repository Structure

```text
.
├── main.tf          # Core AWS VPC, public subnet, and private subnet resources
├── variables.tf     # Parameterized CIDR blocks and Availability Zone inputs
├── versions.tf      # HCP Terraform cloud backend & AWS provider version constraints
├── outputs.tf       # Exported VPC and Subnet IDs for downstream module consumption
├── .gitignore       # Terraform, state, and IDE exclusion rules
└── README.md        # Architecture and operational documentation