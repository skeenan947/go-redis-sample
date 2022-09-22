resource "google_artifact_registry_repository" "samples" {
  location      = "us-west1"
  repository_id = "samples"
  description   = "docker repository"
  format        = "DOCKER"
}