# https://registry.terraform.io/providers/hashicorp/google/6.1.0/docs/resources/compute_managed_ssl_certificate
# gcloud compute ssl-certificates list
# gcloud compute ssl-certificates describe managed-cert-ingress-tf-1

# Créer un certificat SSL géré par Google Cloud pour chaque domaine (4 certificats)
resource "google_compute_managed_ssl_certificate" "managed_cert_ingress_tf_1" {
  name = "managed-cert-ingress-tf-1"

  managed {
    domains = ["maelcstj.duckdns.org"]
  }

    # Ne pas supprimer le certificat SSL car il est long à provisionner
  lifecycle {
    prevent_destroy = true
  }
}

# ...




# Exemple de créer et gérér dans Terraform les éléments qui composes le Ingress

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
# gcloud compute backend-services list
# resource "google_compute_backend_service" "backend_service_ingress_tf" {
#   name        = "backend-service-ingress-tf"
#   protocol    = "HTTPS"
#   port_name   = "https"
#   timeout_sec = 10
# 
#   lifecycle {
#     prevent_destroy       = true
#     create_before_destroy = true
#   }
# }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map
# gcloud compute url-maps list
# resource "google_compute_url_map" "url_map_ingress_tf" {
#   name            = "url-map-ingress-tf"
#   default_service = google_compute_backend_service.backend_service_ingress_tf.self_link
#
#   lifecycle {
#     prevent_destroy       = true
#     create_before_destroy = true
#   }
# }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy
# gcloud compute target-https-proxies list
# resource "google_compute_target_https_proxy" "https_proxy_ingress_tf" {
#   name    = "https-proxy-ingress-tf"
#   url_map = google_compute_url_map.url_map_ingress_tf.self_link
#
#   ssl_certificates = [
#     google_compute_managed_ssl_certificate.managed_cert_ingress_tf_1.self_link,
#     google_compute_managed_ssl_certificate.managed_cert_ingress_tf_2.self_link,
#     google_compute_managed_ssl_certificate.managed_cert_ingress_tf_3.self_link,
#     google_compute_managed_ssl_certificate.managed_cert_ingress_tf_4.self_link
#   ]
#
#   lifecycle {
#     prevent_destroy       = true
#     create_before_destroy = true
#   }
# }

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
# gcloud compute forwarding-rules list
# resource "google_compute_global_forwarding_rule" "https_forwarding_rule_ingress_tf" {
#   name                  = "https-forwarding-rule-ingress-tf"
#   target                = google_compute_target_https_proxy.https_proxy_ingress_tf.self_link
#   port_range            = "443"
#   load_balancing_scheme = "EXTERNAL"
#   ip_protocol           = "TCP"
#
#   # Prevent destruction of the resource with terraform destroy
#   lifecycle {
#     prevent_destroy       = true
#     create_before_destroy = true
#   }
# }
