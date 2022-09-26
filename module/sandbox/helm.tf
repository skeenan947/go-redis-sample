resource "helm_release" "go-redis" {
  chart = "oci://${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.samples.repository_id}"
  name  = "go-redis"
}
