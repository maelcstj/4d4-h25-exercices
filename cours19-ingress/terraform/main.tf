provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_container_cluster" "cluster_test" {
  name                = "cluster-test"
  location            = var.region
  deletion_protection = false

  node_pool {
    name       = "default-pool"
    node_count = 1

    node_config {
      machine_type = "n1-standard-4"
      preemptible  = true
      disk_type    = "pd-ssd"
      disk_size_gb = 20
    }
  }
}