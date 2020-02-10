provider "bigip" {
  address  = var.bigip_address
  username = var.bigip_username
  password = var.bigip_password
}

# HTTP virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_http" {
  name                       = "/Common/terraform_test_vs_http"
  destination                = "10.84.100.100"
  description                = "Terraform Test HTTP Virtual Server"
  port                       = 80
  pool                       = "/Common/terraform_test_pool_http"
  source_address_translation = "automap"
}

resource "bigip_ltm_pool" "terraform_test_pool_http" {
  name                = "/Common/terraform_test_pool_http"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test HTTP Pool"
  monitors            = ["/Common/http"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

# HTTPS virtual server configuration

resource "bigip_ltm_virtual_server" "https" {
  name                       = "/Common/terraform_test_vs_https"
  destination                = "10.84.100.101"
  description                = "Terraform Test HTTPS Virtual Server"
  port                       = 443
  client_profiles            = ["/Common/clientssl"]
  server_profiles            = ["/Common/serverssl"]
  pool                       = "/Common/terraform_test_pool_https"
  source_address_translation = "automap"
}

resource "bigip_ltm_pool" "terraform_test_pool_https" {
  name                = "/Common/terraform_test_pool_https"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test HTTPS Pool"
  monitors            = ["/Common/https"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
