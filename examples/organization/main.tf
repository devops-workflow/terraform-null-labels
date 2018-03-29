module "org" {
  source        = "../../"
  names         = ["CapMe"]
  environment   = "Dev"
  organization  = "CorpXyZ"
  namespace-env = false
  namespace-org = true
}
