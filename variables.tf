# Cato Variables
variable "token" {
  description = "Cato Networks API Token"
  type        = string
  #sensitive   = true
}

variable "account_id" {
  description = "Cato Networks Account ID"
  type        = string
}

variable "site_name" {
  description = "Name of the vsocket site"
  type        = string
}

variable "site_description" {
  description = "Description of the vsocket site"
  type        = string
}

variable "site_location" {
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
}

# Variables
variable "project" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "me-west1"
  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Region must be in the format: region-location (e.g., us-central1)."
  }
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "me-west1-a"
}

variable "vpc_mgmt_name" {
  description = "Management VPC name"
  type        = string
}

variable "vpc_wan_name" {
  description = "WAN VPC name"
  type        = string
}

variable "vpc_lan_name" {
  description = "LAN VPC name"
  type        = string
}

variable "subnet_mgmt_name" {
  description = "Management Subnet name"
  type        = string
}

variable "subnet_wan_name" {
  description = "WAN Subnet name"
  type        = string
}

variable "subnet_lan_name" {
  description = "LAN Subnet name"
  type        = string
}

variable "subnet_mgmt_cidr" {
  description = "Management Subnet CIDR"
  type        = string
}

variable "subnet_wan_cidr" {
  description = "WAN Subnet CIDR"
  type        = string
}

variable "subnet_lan_cidr" {
  description = "LAN Subnet CIDR"
  type        = string
}

variable "ip_mgmt_name" {
  description = "Management Static IP name"
  type        = string
}

variable "ip_wan_name" {
  description = "WAN Static IP name"
  type        = string
}

variable "ip_lan_name" {
  description = "LAN Static IP name"
  type        = string
  default     = "lan-static-ip"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB (minimum 10 GB)"
  type        = number
  default     = 20
  validation {
    condition     = var.boot_disk_size >= 10
    error_message = "Boot disk size must be at least 10 GB."
  }
}

variable "vm_name" {
  description = "VM Instance name (must be 1-63 characters, lowercase letters, numbers, or hyphens)"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.vm_name))
    error_message = "VM name must be 1-63 characters long, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "network_tier" {
  description = "Network tier for the public IP"
  type        = string
  default     = "STANDARD"
}

variable "mgmt_network_ip" {
  description = "Management network IP"
  type        = string
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.mgmt_network_ip))
    error_message = "Management network IP must be a valid IPv4 address."
  }
}

variable "wan_network_ip" {
  description = "WAN network IP"
  type        = string
}

variable "lan_network_ip" {
  description = "LAN network IP"
  type        = string
}

variable "public_ip_mgmt" {
  description = "Whether to assign the existing static IP to management interface. If false, no public IP will be assigned."
  type        = bool
  default     = true
}

variable "public_ip_wan" {
  description = "Whether to assign the existing static IP to WAN interface. If false, no public IP will be assigned."
  type        = bool
  default     = true
}

# Firewall Configuration
variable "firewall_rule_name" {
  description = "Name of the firewall rule (1-63 chars, lowercase letters, numbers, or hyphens)"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.firewall_rule_name))
    error_message = "Firewall rule name must be 1-63 characters, start with a letter, and contain only lowercase letters, numbers, or hyphens."
  }
}

variable "allowed_ports" {
  description = "List of ports to allow through the firewall (Required)"
  type        = list(string)
  validation {
    condition     = length(var.allowed_ports) > 0
    error_message = "At least one port must be specified."
  }
}
variable "management_source_ranges" {
  description = "Source IP ranges that can access the instance via SSH/HTTPS (Required)"
  type        = list(string)
  validation {
    condition     = length(var.management_source_ranges) > 0
    error_message = "At least one source IP range must be provided for management access."
  }
}
variable "create_firewall_rule" {
  description = "Whether to create the firewall rule for management access"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to be appended to GCP resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to be appended to GCP resources"
  type        = list(string)
  default     = []
}

variable "create_lan_default_route" {
  description = "Whether to create a default route in the LAN VPC pointing to the vSocket instance"
  type        = bool
  default     = false
}