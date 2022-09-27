variable "project_id" {
  type        = string
  description = "GCP Project ID"
}
variable "region" {
  type        = string
  description = "The region where resources should be deployed to"
  default     = "us-west1"
}
variable "google_project_services" {
  type        = list(string)
  description = "GCP Services enable"
}
variable "vpc" {
  type        = string
  description = "VPC name"
  default = "vpc-01"
}

variable "main_subnet_ip_range" {
  type        = string
  description = "IP Range for the main subnet (GCE)"
}

variable "gke_pods_range" {
  type        = string
  description = "IP range for the GKE Pods"
}

variable "gke_services_range" {
  type        = string
  description = "IP range for the GKE Services"
}
