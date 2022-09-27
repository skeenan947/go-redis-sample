resource "null_resource" "helm_login" {
  provisioner "local-exec" {
    command = "gcloud auth print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://${var.region}-docker.pkg.dev"
  }
}

resource "helm_release" "go-redis" {
  chart      = "go-redis"
  repository = "oci://${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.samples.repository_id}"
  name       = "go-redis"

  depends_on = [
    null_resource.helm_login
  ]
}
