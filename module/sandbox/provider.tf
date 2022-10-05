terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0"
    }
  }
}
provider "google" {
  project = var.project_id
  region  = var.region
}
provider "google-beta" {
  project = var.project_id
  region  = var.region
}
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "null" {
  # Configuration options
}
