
# https://cloud.google.com/sql/docs/mysql/configure-private-ip#terraform
# Configurer une adresse partagée dans un réseau privé

# Éléments Google Cloud dans Terraform sont liés par les 3 facons suivantes
# - id : Identifiant unique généré par resources Google Cloud (ex. 1d23sa4d5sa153d1sa5ddas)
# - name : Nom unique de l'élément défini par le programmeur (ex. "cluster-test")
# - self_link : Google Cloud fonctionne aussi avec des liens web (ex. https://cloud.google.com/...)

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service
# gcloud services list --project=h25-4d4-xx
# gcloud services enable servicenetworking.googleapis.com --project=h25-4d4-xx
# Ajouter le service de réseautique au projet pour "google_service_networking_connection"
resource "google_project_service" "service_networking" {
  service = "servicenetworking.googleapis.com"
  project = var.project_id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# gcloud compute networks list
# gcloud compute networks describe network-custom-tf
# Définir un réseau privé (VPC) afin de permettre la communication entre divers éléments Google Cloud
# - GKE, bases de données SQL, machines virtuelles, etc.
resource "google_compute_network" "network_custom_tf" {
  name = "network-custom-tf"

  # (Optionnel) Afin de définir nous même les addresses IP avec "google_compute_subnetwork"
  # auto_create_subnetworks = false 
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
# gcloud compute networks subnets list
# gcloud compute networks subnets describe subnetwork-custom-tf --region=us-east1
# (Optionnel) Définir les adresses dans le réseau ci-dessus les adresses 10.0.0.0/24
# Sinon, Google Cloud décidera automatiquement des réseaux créés
# resource "google_compute_subnetwork" "subnetwork_custom_tf" {
#   name          = "subnetwork-custom-tf"
#   network       = google_compute_network.network_custom_tf.id
#   region        = var.region
#   ip_cidr_range = "10.0.0.0/24"
# }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
# gcloud compute addresses list
# gcloud compute addresses describe global-address-range-tf --global
# Définir une plage avec plusieurs addresses IP dans le réseau afin de définir plusieurs éléments partagés
resource "google_compute_global_address" "compute_global_address_range_tf" {
  name          = "global-address-range-tf"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network_custom_tf.id
}

# Définir une seul addresse IP dans le réseau afin de définir un seul élément partagé
# resource "google_compute_global_address" "ompute_global_address_single_ip_tf" {
#   name          = "global-addess-single-ip-tf"
#   purpose       = "PRIVATE_SERVICE_CONNECT"
#   address_type  = "INTERNAL"
#   network       = google_compute_network.network_custom_tf.id
#   address       = "10.0.0.250"
# }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
# gcloud compute networks list-peering-ranges --region=us-east1
# gcloud compute networks describe network-custom-tf --region=us-east1
# Créer le réseau privé (VPC) à l'aide des configuration précédentes du réseau privé
resource "google_service_networking_connection" "network_connection_vpc_tf" {
  service                 = "servicenetworking.googleapis.com"
  network                 = google_compute_network.network_custom_tf.id
  reserved_peering_ranges = [google_compute_global_address.compute_global_address_range_tf.name]

  # Erreur si le service "servicenetworking.googleapis.com" n'est pas activé dans le projet Google Cloud
  # Attendre que le service soit activé dans le projet avant de créer le réseau privé
  depends_on = [google_project_service.service_networking]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
# gcloud compute addresses list
# gcloud compute addresses describe address-ingress-tf --global

# Créer une adresse IP publique reservée pour le Ingress "address_ingress_tf
resource "google_compute_global_address" "address_ingress_tf" {
  name = "address-ingress-tf"

  # Ne pas utiliser le réseau privé afin d'avoir une adresse publique pour le Ingress
  # network = google_compute_network.network_custom_tf.id

  # Ne pas détruire l'adresse IP afin de faire des tests sur les certificats
  # Commenter à la fin de l'exercice, car les adresses publique ont un coût associé
  # lifecycle {
  #   prevent_destroy = true
  # }

  # TODO: Mettre à jour les entrées DNS lorsque l'adresse du Ingress est modifiée
  # self : permet de référencer la resource parent qui vient d'être créée 
  # self.address = google_compute_global_address.address_ingress_tf.address

  provisioner "local-exec" {
    when = create
    command = "echo ${self.address}"
  }

  # DuckDNS (https://www.duckdns.org/install.jsp)
  # 1) Copier le Token est en haut à droite de la page 
  # 2) Exécuter la commande suivante :
  # curl -k "https://www.duckdns.org/update?domains=<my-domain>&token=<my-token>&ip=<my-new-ip>"

  # provisioner "local-exec" {
  #   when = create
  #   command = "curl -k https://www.duckdns.org/update?domains=my-domain&token=my-token&ip=my-new-ip"
  # }

  # Dynu (https://www.dynu.com/en-US/Support/API)
  # 1) Créer un API Key dans API Credentials
  #    Copier la clé sur un des cadenes dans la page de documentation API
  # 2) Trouver le id de l'entrée DDNS avec la commande suivante :
  #    https://www.dynu.com/en-US/Support/API#/dns/dnsGet
  # 3) Mettre à jour l'entrée DDNS avec la commande suivante :
  #    Seuls "name", "ipv4Adress", "ipv4" et "ipv4WildcardAlias" sont obligatoires
  #    https://www.dynu.com/en-US/Support/API#/dns/dnsIdPost
  # provisioner "local-exec" {
  #   when = create
  #   command = <<EOT
  #   curl -X POST "https://api.dynu.com/v2/dns/<domain-id>" \
  #     -H "accept: application/json" \
  #     -H "API-Key: <api-key>" \
  #     -H "Content-Type: application/json" \
  #     -d "{ 
  #           \"name\": \"<domain-name>\", 
  #           \"ipv4Address\": \"<ip-adress>\",
  #           \"ipv4\": true,
  #           \"ipv4WildcardAlias\": true,
  #         }"
  #   EOT
  # }

}



