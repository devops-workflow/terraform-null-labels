module "tags" {
  source       = "../../"
  names        = ["CapMe"]
  environment  = "Dev"
  organization = "CorpXyZ"
  attributes   = ["role", "policy", "use", ""]
  tags         = "${map("Key", "Value")}"
}
