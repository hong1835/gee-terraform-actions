output "gke_name"     { value = google_container_cluster.gke.name }
output "region"       { value = var.region }
output "artifact_url" { value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}" }
