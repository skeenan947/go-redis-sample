variable "project_id" {
  type        = string
  description = "GCP Project ID"
}
variable "region" {
  type        = string
  description = "GCP Region"
}
variable "google_project_services" {
  type        = list(string)
  description = "GCP Services enable"
}
