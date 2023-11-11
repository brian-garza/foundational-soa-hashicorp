# Network Specific Variables
variable "vpc_cidr_block" {
  type        = string
  description = "Cidr block for the VPC.  Using a /22 Subnet Mask for this project is recommended."
}

variable "region" {
  type        = string
  description = "AWS region to deploy the transit gateway to.  Only used for naming purposes."
}

variable "transit_gateway_id" {
  type = string
  description = "transit gateway ID to point traffic to for shared services, hcp, etc."
}

variable "shared_services_cidr_block" {
  type = string
  description = "CIDR block of the shared services sandbox."
}

variable "hcp_hvn_cidr_block" {
  type = string
  description = "CIDR block of the HCP HVN."
}

variable "accessible_cidr_blocks" {
  type = list(string)
  description = "List of CIDR blocks to point to the transit gateway in addition to the Shared Services sandbox and HCP HVN"
  default = []
}

# EC2 Variables
variable "ecs_keypair" {
  type = string
  description = "name of ec2 keypair for accessing container instances"
}

variable "instance_type" {
  type = string
  description = "container instance type (i.e. t3.medium)"
  default = "t3.medium"
}

variable "name" {
  type        = string
  description = "Name of regional resources"
}

## Boundary workers

variable "create_boundary_workers" {
  type        = bool
  description = "Create Boundary workers, one per public subnet"
  default     = false
}

variable "keypair" {
  type        = string
  description = "Keypair"
  default     = null
}

variable "vault_address" {
  type        = string
  description = "Vault cluster address"
  default     = null
}

variable "vault_namespace" {
  type        = string
  description = "Vault cluster namespace"
  default     = null
}

variable "boundary_worker_vault_path" {
  type        = string
  description = "Path in Vault for Boundary worker to store secret"
  default     = null
}

variable "boundary_worker_vault_token" {
  type        = string
  description = "Token in Vault for Boundary worker to store secret"
  sensitive   = true
  default     = null
}

variable "boundary_cluster_id" {
  type        = string
  description = "Boundary cluster ID for workers to register"
  default     = null
}

variable "boundary_project_scope_id" {
  type        = string
  description = "Boundary project scope ID for EKS runtime"
}