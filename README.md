# Cato Networks GCP vSocket VPC Terraform Module

The Cato vSocket modules deploys a vSocket instance to connect to the Cato Cloud.

# Pre-reqs
- Install the [Google Cloud Platform CLI](https://cloud.google.com/sdk/docs/install)
`$ /google-cloud-sdk/install.sh`
- Run the following to configure the GCP CLI
`$ gcloud auth application-default login`

This module deploys the following resources
- 1 google_compute_address (ip_lan)
- 1 google_compute_address (ip_mgmt)
- 1 google_compute_address (ip_wan)
- 1 google_compute_network (vpc_lan)
- 1 google_compute_network (vpc_mgmt)
- 1 google_compute_network (vpc_wan)
- 1 google_compute_subnetwork (subnet_lan)
- 1 google_compute_subnetwork (subnet_mgmt)
- 1 google_compute_subnetwork (subnet_wan)
- 1 google_compute_instance
- 1 google_compute_disk
- 1 google_compute_firewall (optional)

## Usage

```hcl
# GCP/Cato vsocket Module
module "vsocket-gcp-vpc" {
  source                   = "catonetworks/vsocket-gcp-vpc/cato"
  token                    = var.cato_token
  account_id               = var.account_id
  # GCP Project configuration
  project                  = "cato-vsocket-deployment"
  region                   = "us-west1"
  zone                     = "us-west1-a"

  # Cato site and socket configuration
  vm_name                  = "gcp-vsocket-instance"
  site_name                = "Cato-GCP-us-west1"
  site_description         = "GCP Site us-west1"
  site_location            = {
    city         = "Los Angeles"
    country_code = "US"
    state_code   = "US-CA" ## Optional - for countries with states
    timezone     = "America/Los_Angeles"
  }

  allowed_ports            = ["22", "443"]
  create_firewall_rule     = true
  # Firewall configuration
  firewall_rule_name       = "allow-management-access"
  management_source_ranges = ["11.22.33.44/32"]

  # mgmt network configuration
  ip_mgmt_name             = "ba-mgmt-ip"
  mgmt_network_ip          = "10.0.0.10"
  subnet_mgmt_name         = "mgmt-subnet"
  subnet_mgmt_cidr         = "10.0.0.0/24"
  vpc_mgmt_name            = "management-vpc"

  # wan network configuration
  ip_wan_name              = "wan-ip"
  wan_network_ip           = "10.1.0.10"
  subnet_wan_name          = "wan-subnet"
  subnet_wan_cidr          = "10.1.0.0/24"
  vpc_wan_name             = "ba-wan-vpc"

  # lan network configuration
  lan_network_ip           = "10.2.0.10" 
  subnet_lan_name          = "lan-subnet"
  subnet_lan_cidr          = "10.2.0.0/24"
  vpc_lan_name             = "lan-vpc"

  # GCP deployment tags and labels
  tags                     = ["exampletag1", "exampletag2"]
  labels = {
    examplelabel1 = "exampleval1"
    examplelabel2 = "examplelabel2"
  }
}
```