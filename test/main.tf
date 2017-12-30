
module "labels" {
  source        = "../"
  names          = ["CapMe", "Test2"]
  environment   = "Dev"
  organization  = "CorpXyZ"
  namespace-org = true
  #attributes    = ["role", "policy", "use", ""]
  attributes    = ["8080"]
  tags          = "${map("Key", "Value")}"
  autoscaling_group = true
}

/*
module "labels-tags" {
  source        = "../"
  name          = "CapMe"
  environment   = "Dev"
  organization  = "CorpXyZ"
  attributes    = ["role", "policy", "use", ""]
  tags          = "${map("Key", "Value")}"
}
*/
module "labels-disabled" {
  source        = "../"
  names          = ["CapMe"]
  environment   = "Dev"
  organization  = "CorpXyZ"
  enabled       = false
}
/*

module "labels-env" {
  source        = "../"
  name          = "CapMe"
  environment   = "Dev"
  organization  = "CorpXyZ"
  namespace-env = true
  namespace-org = false
}
module "labels-org" {
  source        = "../"
  name          = "CapMe"
  environment   = "Dev"
  organization  = "CorpXyZ"
  namespace-env = false
  namespace-org = true
}
module "labels-org-env" {
  source        = "../"
  name          = "Application"
  environment   = "Environment"
  organization  = "Organization"
  namespace-env = true
  namespace-org = true
}
*/
