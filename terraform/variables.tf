variable "project_id" { type = string }
variable "region"     { type = string  default = "asia-northeast3" }
variable "gke_name"   { type = string  default = "demo-gke" }
variable "network"    { type = string  default = "demo-vpc" }
variable "subnet"     { type = string  default = "demo-subnet" }
variable "subnet_cidr"{ type = string  default = "10.10.0.0/16" }
variable "artifact_repo" { type = string default = "demo-repo" }
