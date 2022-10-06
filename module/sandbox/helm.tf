resource "helm_release" "go-redis" {
  name             = "go-redis"
  chart            = "oci://${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.samples.repository_id}/go-redis"
  namespace        = "go-redis"
  create_namespace = true

  depends_on = [
    null_resource.helm_push,
    module.gke
  ]
}
