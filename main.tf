# Provider configuration
provider "google" {
  project      = var.project
  region       = var.region
}

# VPC Networks
resource "google_compute_network" "vpc_mgmt" {
  name                    = var.vpc_mgmt_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_wan" {
  name                    = var.vpc_wan_name
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_lan" {
  name                    = var.vpc_lan_name
  auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "subnet_mgmt" {
  name          = var.subnet_mgmt_name
  ip_cidr_range = var.subnet_mgmt_cidr
  network       = google_compute_network.vpc_mgmt.id
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_wan" {
  name          = var.subnet_wan_name
  ip_cidr_range = var.subnet_wan_cidr
  network       = google_compute_network.vpc_wan.id
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_lan" {
  name          = var.subnet_lan_name
  ip_cidr_range = var.subnet_lan_cidr
  network       = google_compute_network.vpc_lan.id
  region        = var.region
}

# Static IPs
resource "google_compute_address" "ip_mgmt" {
  count        = var.public_ip_mgmt ? 1 : 0
  name         = var.ip_mgmt_name
  region       = var.region
  network_tier = var.network_tier
}

resource "google_compute_address" "ip_wan" {
  count        = var.public_ip_wan ? 1 : 0
  name         = var.ip_wan_name
  region       = var.region
  network_tier = var.network_tier
}

resource "google_compute_address" "ip_lan" {
  name         = var.ip_lan_name
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.subnet_lan.id
}

module "vsocket-gcp" {
  source                   = "catonetworks/vsocket-gcp/cato"  
  token                    = var.token
  account_id               = var.account_id
  allowed_ports            = var.allowed_ports
  boot_disk_size           = var.boot_disk_size
  create_firewall_rule     = var.create_firewall_rule
  firewall_rule_name       = var.firewall_rule_name
  lan_compute_network_id   = google_compute_network.vpc_lan.id
  lan_network_ip           = var.lan_network_ip
  lan_subnet_id            = google_compute_subnetwork.subnet_lan.id
  native_network_range     = var.subnet_lan_cidr
  management_source_ranges = var.management_source_ranges
  mgmt_compute_network_id  = google_compute_network.vpc_mgmt.id
  mgmt_network_ip          = var.mgmt_network_ip
  mgmt_static_ip_address   = google_compute_address.ip_mgmt[0].address
  mgmt_subnet_id           = google_compute_subnetwork.subnet_mgmt.id
  project                  = var.project
  region                   = var.region
  vm_name                  = var.vm_name
  wan_compute_network_id   = google_compute_network.vpc_wan.id
  wan_network_ip           = var.wan_network_ip
  wan_static_ip_address    = google_compute_address.ip_wan[0].address
  wan_subnet_id            = google_compute_subnetwork.subnet_wan.id
  zone                     = var.zone
  site_name                = var.site_name
  site_description         = var.site_description
  site_location            = var.site_location
  tags                     = var.tags
  labels                   = var.labels
}

# LAN Default Route
resource "google_compute_route" "lan_default_route" {
  count            = var.create_lan_default_route ? 1 : 0
  name             = "route-all-lan-to-${var.vm_name}"
  dest_range       = "0.0.0.0/0"
  network         = google_compute_network.vpc_lan.id
  next_hop_instance = module.vsocket-gcp.instance_id
  priority        = 1000
}

