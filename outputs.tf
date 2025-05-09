# Outputs
output "vpc_mgmt_id" {
  value = google_compute_network.vpc_mgmt.id
}

output "vpc_wan_id" {
  value = google_compute_network.vpc_wan.id
}

output "vpc_lan_id" {
  value = google_compute_network.vpc_lan.id
}

output "subnet_mgmt_id" {
  value = google_compute_subnetwork.subnet_mgmt.id
}

output "subnet_wan_id" {
  value = google_compute_subnetwork.subnet_wan.id
}

output "subnet_lan_id" {
  value = google_compute_subnetwork.subnet_lan.id
}

output "ip_mgmt_address" {
  value = google_compute_address.ip_mgmt[0].address
}

output "ip_wan_address" {
  value = google_compute_address.ip_wan[0].address
}

output "ip_lan_address" {
  value = google_compute_address.ip_lan.address
}

output "cato_license_site" {
  value = var.license_id == null ? null : {
    id           = cato_license.license[0].id
    license_id   = cato_license.license[0].license_id
    license_info = cato_license.license[0].license_info
    site_id      = cato_license.license[0].site_id
  }
}