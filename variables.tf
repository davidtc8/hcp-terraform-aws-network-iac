variable "vpc_cidr" {
  description = "CIDR Block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "CIDR Block for the private subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "private_subnet_az" {
  description = "Availability zone for the private subnet"
  type        = string
  default     = "us-east-2a"
}

variable "public_subnet_cidr" {
  description = "CIDR Block for the public subnet"
  type        = string
  default     = "10.0.100.0/24"
}

variable "public_subnet_az" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-2b"
}