terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
  backend "gcs" {
    # 第一次本地试跑可以先删掉 backend，稳定后再改为远端状态
    # bucket = "YOUR_TF_STATE_BUCKET"
    # prefix = "gke/terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
