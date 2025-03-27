# Virtal network
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# Compute instance (VM)
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance-${var.region}-${count.index}" # Error : name unique
  machine_type = "f1-micro"

  count = 2 # Disponible dasn toutes les Resources

  boot_disk {
    initialize_params {
      #   image = "debian-cloud/debian-11"
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

# Une seule VM / un seul élément
# output "ip" {
#   value = google_compute_instance.vm_instance.network_interface.0.network_ip
# }

output "vm_external_ip_0" {
  value = google_compute_instance.vm_instance[0].network_interface[0].access_config[0].nat_ip
}

output "vm_external_ips" {
  value = [for instance in google_compute_instance.vm_instance : instance.network_interface[0].access_config[0].nat_ip]
}