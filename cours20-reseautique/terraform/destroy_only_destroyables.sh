# TODO: Lister les ressources à supprimer dans le format -target resource1 -target resource2 ...

# networking.tf
# resource "google_compute_network" "network_custom_tf"
# resource "google_compute_global_address" "compute_global_address_range_tf"
# resource "google_service_networking_connection" "network_connection_vpc_tf"
# (not deleted) resource "google_compute_global_address" "address_ingress_tf" 

# main.tf
# resource "google_container_cluster" "cluster_test"
# resource "google_sql_database_instance" "my-sql-instance"
terraform destroy \
    -target google_compute_network.network_custom_tf \
    -target google_compute_global_address.compute_global_address_range_tf \
    -target google_service_networking_connection.network_connection_vpc_tf \
    -target google_container_cluster.cluster_test \
    -target google_sql_database_instance.my-sql-instance