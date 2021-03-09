# HTTPS virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_https" {
  name                       = "/Common/terraform_test_vs_https"
  destination                = "10.0.0.101"
  description                = "Terraform Test HTTPS Virtual Server"
  port                       = 443
  client_profiles            = [bigip_ltm_profile_client_ssl.terraform_test_profile_client_ssl.name]
  server_profiles            = ["/Common/serverssl"]
  pool                       = bigip_ltm_pool.terraform_test_pool_https.name
  source_address_translation = "automap"
}

# HTTPS pool configuration

resource "bigip_ltm_pool" "terraform_test_pool_https" {
  name                = "/Common/terraform_test_pool_https"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test HTTPS Pool"
  monitors            = ["/Common/https"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

# HTTPS node/pool attachment

resource "bigip_ltm_pool_attachment" "terraform_test_node_attach_https" {
  pool = bigip_ltm_pool.terraform_test_pool_https.name
  node = "${bigip_ltm_node.terraform_test_node.name}:443"
}

# SSL profile configuration

resource "bigip_ltm_profile_client_ssl" "terraform_test_profile_client_ssl" {
  name          = "/Common/example.com"
  cert          = bigip_ssl_certificate.terraform_test_ssl_certificate.name
  key           = bigip_ssl_key.terraform_test_ssl_key.name
  chain         = "none"
  partition     = "Common"
  defaults_from = "/Common/clientssl"
  authenticate  = "always"
  ciphers       = "DEFAULT"
}

# SSL certificate configuration

resource "bigip_ssl_key" "terraform_test_ssl_key" {
  name      = "/Common/example.com.key"
  content   = tls_private_key.terraform_test_tls_private_key.private_key_pem
  partition = "Common"
}

resource "bigip_ssl_certificate" "terraform_test_ssl_certificate" {
  name      = "/Common/example.com.crt"
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
