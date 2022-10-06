resource "google_artifact_registry_repository" "samples" {
  location      = var.region
  repository_id = "docker-repo"
  description   = "docker repository"
  format        = "DOCKER"
}

resource "null_resource" "helm_login" {
  provisioner "local-exec" {
    command = "gcloud auth print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://us-west1-docker.pkg.dev"
     }
  depends_on = [
    google_artifact_registry_repository.samples
  ]
}
resource "null_resource" "helm_push" {
  provisioner "local-exec" {
    command = "helm push ../../chart/go-redis/go-redis-0.1.0.tgz oci://us-west1-docker.pkg.dev/go-redis/docker-repo"
     }
  depends_on = [
    null_resource.helm_login
  ]
}
