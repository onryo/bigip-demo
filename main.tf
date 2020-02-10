provider "bigip" {
  address  = var.bigip_url
  username = var.bigip_username
  password = var.bigip_password
}

# HTTP virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_http" {
  name        = "/Common/terraform_test_vs_http"
  destination = "10.84.100.100"
  description = "Terraform Test HTTP Virtual Server"
  ip_protocol = "tcp"
  port        = 80
  profiles = [
    "/Common/tcp",
    "/Common/terraform_test_profile_http"
  ]
  pool                       = "/Common/terraform_test_pool_http"
  source_address_translation = "automap"
  depends_on = [
    bigip_ltm_pool.terraform_test_pool_http,
    bigip_ltm_profile_http.terraform_test_profile_http
  ]
}

resource "bigip_ltm_pool" "terraform_test_pool_http" {
  name                = "/Common/terraform_test_pool_http"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test HTTP Pool"
  monitors = [
    "/Common/http"
  ]
  allow_snat = "yes"
  allow_nat  = "yes"
}

# HTTPS virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_https" {
  name        = "/Common/terraform_test_vs_https"
  destination = "10.84.100.101"
  description = "Terraform Test HTTPS Virtual Server"
  port        = 443
  client_profiles = [
    "/Common/example.com"
  ]
  server_profiles = [
    "/Common/serverssl"
  ]
  pool                       = "/Common/terraform_test_pool_https"
  source_address_translation = "automap"
  depends_on = [
    bigip_ltm_pool.terraform_test_pool_https
  ]
}

resource "bigip_ltm_pool" "terraform_test_pool_https" {
  name                = "/Common/terraform_test_pool_https"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test HTTPS Pool"
  monitors = [
    "/Common/https"
  ]
  allow_snat = "yes"
  allow_nat  = "yes"
}

# HTTP profile configuration

resource "bigip_ltm_profile_http" "terraform_test_profile_http" {
  name          = "/Common/terraform_test_profile_http"
  defaults_from = "/Common/http"
  description   = "Terraform Test HTTP Profile"
  fallback_host = "https://f5.com/"
  fallback_status_codes = [
    "400",
    "500",
    "300"
  ]
}

# SSL profile configuration

resource "bigip_ltm_profile_client_ssl" "terraform_test_profile_client_ssl" {
  name          = "/Common/example.com"
  cert          = "/Common/example.com.crt"
  key           = "/Common/example.com.key"
  chain         = "none"
  partition     = "Common"
  defaults_from = "/Common/clientssl"
  authenticate  = "always"
  ciphers       = "DEFAULT"
  depends_on = [
    bigip_ssl_key.terraform_test_ssl_key,
    bigip_ssl_certificate.terraform_test_ssl_certificate
  ]
}

# SSL certificate configuration

resource "bigip_ssl_key" "terraform_test_ssl_key" {
  name      = "example.com.key"
  content   = tls_private_key.terraform_test_tls_private_key.private_key_pem
  partition = "Common"
}

resource "bigip_ssl_certificate" "terraform_test_ssl_certificate" {
  name      = "example.com.crt"
  content   = tls_self_signed_cert.terraform_test_tls_self_signed_cert.cert_pem
  partition = "Common"
}

# SSL certificate generator

resource "tls_private_key" "terraform_test_tls_private_key" {
  algorithm   = "RSA"
}

resource "tls_self_signed_cert" "terraform_test_tls_self_signed_cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.terraform_test_tls_private_key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
