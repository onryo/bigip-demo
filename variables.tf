variable "bigip_url" {
  description = "Management URL of F5 BIG-IP"
}

variable "bigip_username" {
  default     = "admin"
  description = "Management username for F5 BIG-IP"
}

variable "bigip_password" {
  default     = "admin"
  description = "Management password for F5 BIG-IP"
}
