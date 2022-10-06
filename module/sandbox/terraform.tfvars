project_id = "go-redis"
region     = "us-west1"

google_project_services = [
  "iam.googleapis.com",
  "compute.googleapis.com",
  "dns.googleapis.com",
  "container.googleapis.com",
  "secretmanager.googleapis.com",
  "servicenetworking.googleapis.com"
]

main_subnet_ip_range = "10.14.0.0/16"
gke_pods_range       = "10.15.0.0/16"
gke_services_range   = "10.16.0.0/20"
