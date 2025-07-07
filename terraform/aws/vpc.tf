module "vpc" {
  source = "github.com/cds-snc/terraform-modules//vpc?ref=v10.6.2"
  name   = "Valentine_VPC"

  allow_https_request_in           = true
  allow_https_request_in_response  = true
  allow_https_request_out          = true
  allow_https_request_out_response = true

  cidrsubnet_newbits = 8
  availability_zones = 3
  single_nat_gateway = true

  billing_tag_value = var.billing_code
}
