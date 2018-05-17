module "complete" {
  source        = "../../"
  names         = ["CapMe", "Test2"]
  environment   = "Dev"
  organization  = "CorpXyZ"
  namespace-org = true

  #attributes    = ["role", "policy", "use", ""]
  attributes = ["8080"]
  tags       = "${map("Key", "Value")}"
}
