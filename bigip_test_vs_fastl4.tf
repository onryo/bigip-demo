# FastL4 virtual server configuration

resource "bigip_ltm_virtual_server" "terraform_test_vs_fastl4" {
  name        = "/Common/terraform_test_vs_fastl4"
  destination = "10.0.0.102"
  description = "Terraform Test FastL4 Virtual Server"
  port        = 80
  pool                       = "/Common/terraform_test_pool_fastl4"
  source_address_translation = "automap"
  depends_on = [
    bigip_ltm_pool.terraform_test_pool_fastl4,
  ]
}

# FastL4 pool configuration

resource "bigip_ltm_pool" "terraform_test_pool_fastl4" {
  name                = "/Common/terraform_test_pool_fastl4"
  load_balancing_mode = "round-robin"
  description         = "Terraform Test FastL4 Pool"
  monitors = [
    "/Common/tcp_half_open"
  ]
  allow_snat = "yes"
  allow_nat  = "yes"
}