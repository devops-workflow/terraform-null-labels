module "env" {
  source        = "../../"
  names         = ["CapMe"]
  environment   = "Dev"
  organization  = "CorpXyZ"
  namespace-env = true
  namespace-org = false
}
