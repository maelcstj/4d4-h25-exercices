output "db_ip" {
  description = "Internal IP address of the database"
  value       = google_sql_database_instance.my-sql-instance.private_ip_address
}

# TODO: Ajouter l'adresse IP du Ingress en output
output "ingress_ip" {
  description = "Global static IP address for the ingress"
  value       = google_compute_global_address.address_ingress_tf.address
}