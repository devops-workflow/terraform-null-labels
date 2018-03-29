module "disabled" {
  source       = "../../"
  names        = ["CapMe"]
  environment  = "Dev"
  organization = "CorpXyZ"
  enabled      = false
}
