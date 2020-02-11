# HTTP virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_http" {
  name        = "/Common/terraform_test_vs_http"
  destination = "10.0.0.100"
  description = "Terraform Test HTTP Virtual Server"
  ip_protocol = "tcp"
  port        = 80
  profiles = [
    "/Common/tcp",
    bigip_ltm_profile_http.terraform_test_profile_http.name
  ]
  pool                       = bigip_ltm_pool.terraform_test_pool_http.name
  source_address_translation = "automap"
}

# HTTP pool configuration

resource "bigip_ltm_pool" "terraform_test_pool_http" {
  name                = "/Common/terraform_test_pool_http"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test HTTP Pool"
  monitors            = [bigip_ltm_monitor.terraform_test_http_monitor.name]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

# HTTP node/pool attachment

resource "bigip_ltm_pool_attachment" "terraform_test_node_attach_http" {
  pool = bigip_ltm_pool.terraform_test_pool_http.name
  node = "${bigip_ltm_node.terraform_test_node.name}:80"
}

# HTTP monitor configuration

resource "bigip_ltm_monitor" "terraform_test_http_monitor" {
  name     = "/Common/terraform_test_http_monitor"
  parent   = "/Common/http"
  send     = "GET /\r\n"
  timeout  = "361"
  interval = "120"
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