#
# Terraform module to provide consistent naming
#
# TODO:
#   Change where replace is done. Move to earlier in process. On initial `name`?
#   Create tags_asg list from tags map. If possible
#   New input tags_asg -> tags_asg with standard tags added

module "autoscaling_group" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.autoscaling_group}"
}
module "enabled" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.enabled}"
}
module "namespace-env" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.namespace-env}"
}
module "namespace-org" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.namespace-org}"
}

locals = {
  attr  = "${lower(format("%s", join(var.delimiter, compact(var.attributes))))}"
  env   = "${lower(format("%s", var.environment))}"
  org   = "${lower(format("%s", var.organization))}"
}
resource "null_resource" "names" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    id  = "${replace(lower(format("%s", element(var.names, count.index))),"_","-")}"
  }
}
resource "null_resource" "env" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    id  = "${module.namespace-env.value ?
      join(var.delimiter, list(local.env, element(null_resource.names.*.triggers.id, count.index))) :
      element(null_resource.names.*.triggers.id, count.index)}"
  }
}
resource "null_resource" "org" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    id  = "${module.namespace-org.value ?
      join(var.delimiter, list(local.org, element(null_resource.env.*.triggers.id, count.index))) :
      element(null_resource.env.*.triggers.id, count.index)}"
  }
}
resource "null_resource" "ids" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    id  = "${length(local.attr) > 0 ?
      join(var.delimiter, list(element(null_resource.org.*.triggers.id, count.index), local.attr)) :
      element(null_resource.org.*.triggers.id, count.index)}"
  }
}
resource "null_resource" "ids-trunc" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    id_20       = "${substr(element(null_resource.ids.*.triggers.id, count.index),0,19 <= length(element(null_resource.ids.*.triggers.id, count.index)) ? 19 : length(element(null_resource.ids.*.triggers.id, count.index)))}"
    id_32       = "${substr(element(null_resource.ids.*.triggers.id, count.index),0,31 <= length(element(null_resource.ids.*.triggers.id, count.index)) ? 31 : length(element(null_resource.ids.*.triggers.id, count.index)))}"
    org_attr_20 = "${min(18 - length(local.attr), length(element(null_resource.org.*.triggers.id, count.index)))}"
    org_attr_32 = "${min(30 - length(local.attr), length(element(null_resource.org.*.triggers.id, count.index)))}"
  }
}
resource "null_resource" "ids-trunc-attr" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    id_attr_20  = "${19 <= length(element(null_resource.ids.*.triggers.id, count.index)) ?
      join(var.delimiter,
        list(
          substr(element(null_resource.org.*.triggers.id, count.index),0,
            element(null_resource.ids-trunc.*.triggers.org_attr_20, count.index) >= 0 ?
              element(null_resource.ids-trunc.*.triggers.org_attr_20, count.index) : 0)
        ),
        list(local.attr)
      )
      : element(null_resource.ids.*.triggers.id, count.index)}"
    id_attr_32  = "${31 <= length(element(null_resource.ids.*.triggers.id, count.index)) ?
      join(var.delimiter,
        list(
          substr(element(null_resource.org.*.triggers.id, count.index),0,
            element(null_resource.ids-trunc.*.triggers.org_attr_32, count.index) >= 0 ?
              element(null_resource.ids-trunc.*.triggers.org_attr_32, count.index) : 0)
        ),
        list(local.attr)
      )
      : element(null_resource.ids.*.triggers.id, count.index)}"
  }
}
/*
resource "null_resource" "tags" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  triggers = {
    #TODO: only add Organization if not ""
    tags  = "${ merge(
      var.tags,
      map(
        "Name", "${element(null_resource.ids.*.triggers.id, count.index)}",
        "Environment", "${local.env}",
        "Organization", "${local.org}",
        "Terraform", "true"
      )
    )}"
  }
}
*/
/*
resource "null_resource" "this" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  # TODO: change all name related refs to array refs
  # split into multi resources to be able to reference created labels
  triggers = {
  }
  lifecycle {
    create_before_destroy = true
  }
}
*/
