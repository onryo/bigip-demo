provider "bigip" {
  address  = var.bigip_url
  username = var.bigip_username
  password = var.bigip_password
}

# HTTP node configuration

resource "bigip_ltm_node" "terraform_test_node" {
  name             = "/Common/terraform_test_node"
  address          = "www.hashicorp.com"
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"
  description      = "www.hashicorp.com"
  rate_limit       = "disabled"
}