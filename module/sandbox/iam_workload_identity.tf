resource "google_iam_workload_identity_pool" "my-pool" {
  workload_identity_pool_id = "my-pool"
  display_name              = "my-pool"
  description               = "Identity pool for GitHub Action"
  project                   = var.project_id
}
