module "org-env" {
  source        = "../../"
  names         = ["Application"]
  environment   = "Environment"
  organization  = "Organization"
  namespace-env = true
  namespace-org = true
}
