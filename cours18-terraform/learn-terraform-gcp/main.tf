terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "vm" {
  source = "./modules/vm"

  # Passer les variables en paramètre
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

# ##################################################################################
# ### Google SQL Database Instance
# ##################################################################################
# Documentation : https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
# gcloud sql connect my-mysql-instance --user=root
# gcloud sql connect my-mysql-instance --user=dbuser --password=secure-password
# gcloud sql instances list
# mysql -h <ip> -u dbuser -p
resource "google_sql_database_instance" "mysql_instance" {
  name   = "my-mysql-instance"
  region = var.region

  # Liste des versions disponibles
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version-1
  # https://cloud.google.com/sql/docs/db-versions
  database_version = "MYSQL_8_0"

  # Error : destroy (apply => destroy)
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "mysql_user" {
  instance = google_sql_database_instance.mysql_instance.name
  name     = var.mysql_user
  password = var.mysql_password # Warning: Available Write-only Attribute Alternative (password)

}

resource "google_sql_database" "mysql_db" {
  instance = google_sql_database_instance.mysql_instance.name
  name     = "mydatabase"
}

output "db_instance_connection_name" {
  value = google_sql_database_instance.mysql_instance.connection_name
}


# ##################################################################################
# ### Container Cluster
# ##################################################################################
# Documentation : https://registry.terraform.io/providers/hashicorp/google/3.14.0/docs/resources/container_cluster
resource "google_container_cluster" "cluster_test" {
  name     = "cluster-test"
  location = var.region

  # Error: Cannot destroy cluster because deletion_protection is set to true. Set it to false to proceed with cluster deletion.
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