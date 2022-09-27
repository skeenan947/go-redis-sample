resource "google_compute_network" "vpc-network" {
  name                    = var.vpc
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "main-subnet" {
  name                     = "${var.region}-gce-subnet"
  ip_cidr_range            = var.main_subnet_ip_range
  network                  = google_compute_network.vpc-network.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "${var.region}-gke-pods-range"
    ip_cidr_range = var.gke_pods_range
  }
  secondary_ip_range {
    range_name    = "${var.region}-gke-services-range"
    ip_cidr_range = var.gke_services_range
  }
}
