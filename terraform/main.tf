resource "google_compute_network" "vpc" {
  name                    = var.network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.region
  private_ip_google_access = true
}

# 打开必要的 API（第一次项目常需要）
resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "artifactregistry.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ])
  service = each.key
}

# Artifact Registry 仓库（Docker）
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.artifact_repo
  description   = "demo docker repo"
  format        = "DOCKER"
  depends_on    = [google_project_service.services]
}

# GKE 标准集群（开启 Workload Identity）
resource "google_container_cluster" "gke" {
  name     = var.gke_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {}
  depends_on = [google_project_service.services]
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "general-pool"
  location   = var.region
  cluster    = google_container_cluster.gke.name

  node_count = 3
  node_config {
    machine_type = "e2-standard-2"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    labels = { role = "general" }
    metadata = { disable-legacy-endpoints = "true" }
  }
}
