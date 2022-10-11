resource "google_artifact_registry_repository" "samples" {
  location      = var.region
  repository_id = "docker-repo"
  description   = "docker repository"
  format        = "DOCKER"
}