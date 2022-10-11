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