# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

resource "null_resource" "enable_service_usage_api" {
  provisioner "local-exec" {
    command = "gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com --project ${var.project_id}"
  }
}
resource "google_project_service" "project" {
  for_each = toset(var.google_project_services)
  project  = var.project_id
  service  = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
  disable_on_destroy         = false

  depends_on = [
    null_resource.enable_service_usage_api
  ]
}
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  version                    = "23.1.0"
  project_id                 = var.project_id
  name                       = "gke-cluster-01"
  region                     = var.region
  network                    = google_compute_network.vpc-network.name
  subnetwork                 = google_compute_subnetwork.main-subnet.name
  ip_range_pods              = "${var.region}-gke-pods-range"
  ip_range_services          = "${var.region}-gke-services-range"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.0.0/28"
  istio                      = false
  cloudrun                   = false
  dns_cache                  = false

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "n1-standard-1"
      min_count                 = 2
      max_count                 = 4
      local_ssd_count           = 0
      spot                      = false
      local_ssd_ephemeral_count = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      preemptible               = false
      initial_node_count        = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }

  depends_on = [
    google_project_service.project
  ]
}
