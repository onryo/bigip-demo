# HTTPS virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_https" {
  name        = "/Common/terraform_test_vs_https"
  destination = "10.0.0.101"
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
    bigip_ltm_pool.terraform_test_pool_https,
    bigip_ltm_profile_client_ssl.terraform_test_profile_client_ssl
  ]
}

# HTTPS pool configuration

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
  algorithm = "RSA"
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
