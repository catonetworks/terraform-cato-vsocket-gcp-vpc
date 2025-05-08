# Cato Networks GCP vSocket VPC Terraform Module

The Cato vSocket modules deploys a vSocket instance to connect to the Cato Cloud.

# Pre-reqs
- Install the [Google Cloud Platform CLI](https://cloud.google.com/sdk/docs/install)
`$ /google-cloud-sdk/install.sh`
- Run the following to configure the GCP CLI
`$ gcloud auth application-default login`

## NOTE
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).

## Usage

```hcl
provider "google" {
  project = var.project
  region  = var.region
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.token
  account_id = var.account_id
}

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
  create_lan_default_route = true  # Optional: Create a default route in LAN VPC pointing to vSocket instance

  # GCP deployment tags and labels
  tags                     = ["exampletag1", "exampletag2"]
  labels = {
    examplelabel1 = "exampleval1"
    examplelabel2 = "examplelabel2"
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vsocket-gcp"></a> [vsocket-gcp](#module\_vsocket-gcp) | catonetworks/vsocket-gcp/cato | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.ip_lan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.ip_mgmt](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.ip_wan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_network.vpc_lan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_network.vpc_mgmt](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_network.vpc_wan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_route.lan_default_route](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route) | resource |
| [google_compute_subnetwork.subnet_lan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.subnet_mgmt](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.subnet_wan](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ports"></a> [allowed\_ports](#input\_allowed\_ports) | List of ports to allow through the firewall (Required) | `list(string)` | n/a | yes |
| <a name="input_boot_disk_size"></a> [boot\_disk\_size](#input\_boot\_disk\_size) | Boot disk size in GB (minimum 10 GB) | `number` | `20` | no |
| <a name="input_create_firewall_rule"></a> [create\_firewall\_rule](#input\_create\_firewall\_rule) | Whether to create the firewall rule for management access | `bool` | `true` | no |
| <a name="input_create_lan_default_route"></a> [create\_lan\_default\_route](#input\_create\_lan\_default\_route) | Whether to create a default route in the LAN VPC pointing to the vSocket instance | `bool` | `false` | no |
| <a name="input_firewall_rule_name"></a> [firewall\_rule\_name](#input\_firewall\_rule\_name) | Name of the firewall rule (1-63 chars, lowercase letters, numbers, or hyphens) | `string` | n/a | yes |
| <a name="input_ip_lan_name"></a> [ip\_lan\_name](#input\_ip\_lan\_name) | LAN Static IP name | `string` | `"lan-static-ip"` | no |
| <a name="input_ip_mgmt_name"></a> [ip\_mgmt\_name](#input\_ip\_mgmt\_name) | Management Static IP name | `string` | n/a | yes |
| <a name="input_ip_wan_name"></a> [ip\_wan\_name](#input\_ip\_wan\_name) | WAN Static IP name | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to be appended to GCP resources | `map(string)` | `{}` | no |
| <a name="input_lan_network_ip"></a> [lan\_network\_ip](#input\_lan\_network\_ip) | LAN network IP | `string` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_management_source_ranges"></a> [management\_source\_ranges](#input\_management\_source\_ranges) | Source IP ranges that can access the instance via SSH/HTTPS (Required) | `list(string)` | n/a | yes |
| <a name="input_mgmt_network_ip"></a> [mgmt\_network\_ip](#input\_mgmt\_network\_ip) | Management network IP | `string` | n/a | yes |
| <a name="input_network_tier"></a> [network\_tier](#input\_network\_tier) | Network tier for the public IP | `string` | `"STANDARD"` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP Project ID | `string` | n/a | yes |
| <a name="input_public_ip_mgmt"></a> [public\_ip\_mgmt](#input\_public\_ip\_mgmt) | Whether to assign the existing static IP to management interface. If false, no public IP will be assigned. | `bool` | `true` | no |
| <a name="input_public_ip_wan"></a> [public\_ip\_wan](#input\_public\_ip\_wan) | Whether to assign the existing static IP to WAN interface. If false, no public IP will be assigned. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP Region | `string` | `"me-west1"` | no |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the vsocket site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | n/a | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | n/a | yes |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the vsocket site | `string` | n/a | yes |
| <a name="input_subnet_lan_cidr"></a> [subnet\_lan\_cidr](#input\_subnet\_lan\_cidr) | LAN Subnet CIDR | `string` | n/a | yes |
| <a name="input_subnet_lan_name"></a> [subnet\_lan\_name](#input\_subnet\_lan\_name) | LAN Subnet name | `string` | n/a | yes |
| <a name="input_subnet_mgmt_cidr"></a> [subnet\_mgmt\_cidr](#input\_subnet\_mgmt\_cidr) | Management Subnet CIDR | `string` | n/a | yes |
| <a name="input_subnet_mgmt_name"></a> [subnet\_mgmt\_name](#input\_subnet\_mgmt\_name) | Management Subnet name | `string` | n/a | yes |
| <a name="input_subnet_wan_cidr"></a> [subnet\_wan\_cidr](#input\_subnet\_wan\_cidr) | WAN Subnet CIDR | `string` | n/a | yes |
| <a name="input_subnet_wan_name"></a> [subnet\_wan\_name](#input\_subnet\_wan\_name) | WAN Subnet name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be appended to GCP resources | `list(string)` | `[]` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | VM Instance name (must be 1-63 characters, lowercase letters, numbers, or hyphens) | `string` | n/a | yes |
| <a name="input_vpc_lan_name"></a> [vpc\_lan\_name](#input\_vpc\_lan\_name) | LAN VPC name | `string` | n/a | yes |
| <a name="input_vpc_mgmt_name"></a> [vpc\_mgmt\_name](#input\_vpc\_mgmt\_name) | Management VPC name | `string` | n/a | yes |
| <a name="input_vpc_wan_name"></a> [vpc\_wan\_name](#input\_vpc\_wan\_name) | WAN VPC name | `string` | n/a | yes |
| <a name="input_wan_network_ip"></a> [wan\_network\_ip](#input\_wan\_network\_ip) | WAN network IP | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | GCP Zone | `string` | `"me-west1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cato_license_site"></a> [cato\_license\_site](#output\_cato\_license\_site) | n/a |
| <a name="output_ip_lan_address"></a> [ip\_lan\_address](#output\_ip\_lan\_address) | n/a |
| <a name="output_ip_mgmt_address"></a> [ip\_mgmt\_address](#output\_ip\_mgmt\_address) | n/a |
| <a name="output_ip_wan_address"></a> [ip\_wan\_address](#output\_ip\_wan\_address) | n/a |
| <a name="output_subnet_lan_id"></a> [subnet\_lan\_id](#output\_subnet\_lan\_id) | n/a |
| <a name="output_subnet_mgmt_id"></a> [subnet\_mgmt\_id](#output\_subnet\_mgmt\_id) | n/a |
| <a name="output_subnet_wan_id"></a> [subnet\_wan\_id](#output\_subnet\_wan\_id) | n/a |
| <a name="output_vpc_lan_id"></a> [vpc\_lan\_id](#output\_vpc\_lan\_id) | n/a |
| <a name="output_vpc_mgmt_id"></a> [vpc\_mgmt\_id](#output\_vpc\_mgmt\_id) | Outputs |
| <a name="output_vpc_wan_id"></a> [vpc\_wan\_id](#output\_vpc\_wan\_id) | n/a |
<!-- END_TF_DOCS -->