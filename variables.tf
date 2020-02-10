variable "bigip_address" {
  description = "Management address of F5 BIG-IP"
}

variable "bigip_username" {
  default     = "admin"
  description = "Username for F5 BIG-IP"
}

variable "bigip_password" {
  default     = "admin"
  description = "Password for F5 BIG-IP"
}
