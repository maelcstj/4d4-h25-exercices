provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# gcloud compute networks list
# gcloud compute networks describe network-custom-tf --region=us-east1
resource "google_container_cluster" "cluster_test" {
  name                = "cluster-test"
  location            = var.region
  deletion_protection = false

  # Ajouter au réseau privé (VPC) afin de pouvoir communiquer avec la base de données
  network = google_compute_network.network_custom_tf.name

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

  # Attendre que le réseau privé (VPC) soit créé avant de créer le cluster
  depends_on = [google_service_networking_connection.network_connection_vpc_tf]

  # Lorsque le cluster est créée, utiliser le cluster créé pour les commandes kubectl
  # gcloud container clusters get-credentials --zone=us-east1 cluster-test
  provisioner "local-exec" {
    when = create
    command = "gcloud container clusters get-credentials --zone=${var.region} ${self.name}"
    interpreter = [ "bash", "-c" ]
  }

  # Lorsque le cluster est détruit, utiliser Docker Desktop pour les commandes kubectl
  # kubectl config set-context docker-desktop
  provisioner "local-exec" {
    when = destroy
    command = "kubectl config set-context docker-desktop"
    interpreter = [ "bash", "-c" ]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# gcloud compute networks list
# gcloud compute networks describe network-custom-tf --region=us-east1
resource "google_sql_database_instance" "my-sql-instance" {
  name             = "my-sql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-n1-standard-1"

    # Configurer une adresse privée seulement pour la base de données
    ip_configuration {
      ipv4_enabled = false # Enlever adresse publique
      private_network = google_compute_network.network_custom_tf.id # Attribue au réseau VPC privé
    }

    # TODO: Vérifier si toujours possible de se connecter avec gcloud sans adresse publique
    # gcloud sql connect my-sql-instance --user=my-custom-user
  }

  # TODO: Vérifier si fonctionnel
  # Lorsque la base de données est créée, ajouter une table users avec du contenu si la table n'existe pas
  provisioner "local-exec" {
    when        = create
    command     = <<EOT
      gcloud sql connect ${self.name} --user=${var.mysql_user} --quiet <<SQL
      
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
      );

      INSERT INTO users (name, email) VALUES 
        ('Al', 'al@example.com'),
        ('Bob', 'bob@example.com'),
        ('Carl', 'carl@example.com')
      ON DUPLICATE KEY UPDATE name=name;
      SQL
    EOT
    interpreter = ["bash", "-c"]
  }

  # Attendre que le réseau privé (VPC) soit créé avant de créer la base de données
  depends_on = [google_service_networking_connection.network_connection_vpc_tf]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
# gcloud sql users list --instance=my-sql-instance
# gcloud sql users describe my-sql-user --instance=my-sql-instance
resource "google_sql_user" "my-sql-user" {
  name        = var.mysql_user
  password_wo = var.mysql_password
  instance    = google_sql_database_instance.my-sql-instance.name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
# gcloud sql databases list --instance=my-sql-instance
# gcloud sql databases describe my-database --instance=my-sql-instance
resource "google_sql_database" "my-database" {
  name     = var.mysql_database
  instance = google_sql_database_instance.my-sql-instance.name
}