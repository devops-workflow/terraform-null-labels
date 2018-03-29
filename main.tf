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
  attr = "${lower(format("%s", join(var.delimiter, compact(var.attributes))))}"
  env  = "${lower(format("%s", var.environment))}"
  org  = "${lower(format("%s", var.organization))}"
}

# TODO: Change to data sources
data "null_data_source" "names" {
  count = "${module.enabled.value ? length(var.names) : 0}"

  inputs = {
    id = "${replace(lower(format("%s", element(var.names, count.index))),"_","-")}"
  }
}

data "null_data_source" "env" {
  count = "${module.enabled.value ? length(var.names) : 0}"

  inputs = {
    id = "${module.namespace-env.value ?
      join(var.delimiter, list(local.env, element(data.null_data_source.names.*.outputs.id, count.index))) :
      element(data.null_data_source.names.*.outputs.id, count.index)}"
  }
}

data "null_data_source" "org" {
  count = "${module.enabled.value ? length(var.names) : 0}"

  inputs = {
    id = "${module.namespace-org.value ?
      join(var.delimiter, list(local.org, element(data.null_data_source.env.*.outputs.id, count.index))) :
      element(data.null_data_source.env.*.outputs.id, count.index)}"
  }
}

data "null_data_source" "ids" {
  count = "${module.enabled.value ? length(var.names) : 0}"

  inputs = {
    id = "${length(local.attr) > 0 ?
      join(var.delimiter, list(element(data.null_data_source.org.*.outputs.id, count.index), local.attr)) :
      element(data.null_data_source.org.*.outputs.id, count.index)}"
  }
}

data "null_data_source" "ids-trunc" {
  count = "${module.enabled.value ? length(var.names) : 0}"

  inputs = {
    id_20       = "${substr(element(data.null_data_source.ids.*.outputs.id, count.index),0,19 <= length(element(data.null_data_source.ids.*.outputs.id, count.index)) ? 19 : length(element(data.null_data_source.ids.*.outputs.id, count.index)))}"
    id_32       = "${substr(element(data.null_data_source.ids.*.outputs.id, count.index),0,31 <= length(element(data.null_data_source.ids.*.outputs.id, count.index)) ? 31 : length(element(data.null_data_source.ids.*.outputs.id, count.index)))}"
    org_attr_20 = "${min(18 - length(local.attr), length(element(data.null_data_source.org.*.outputs.id, count.index)))}"
    org_attr_32 = "${min(30 - length(local.attr), length(element(data.null_data_source.org.*.outputs.id, count.index)))}"
  }
}

data "null_data_source" "ids-trunc-attr" {
  count = "${module.enabled.value ? length(var.names) : 0}"

  inputs = {
    id_attr_20 = "${19 <= length(element(data.null_data_source.ids.*.outputs.id, count.index)) ?
      join(var.delimiter,
        list(
          substr(element(data.null_data_source.org.*.outputs.id, count.index),0,
            element(data.null_data_source.ids-trunc.*.outputs.org_attr_20, count.index) >= 0 ?
              element(data.null_data_source.ids-trunc.*.outputs.org_attr_20, count.index) : 0)
        ),
        list(local.attr)
      )
      : element(data.null_data_source.ids.*.outputs.id, count.index)}"

    id_attr_32 = "${31 <= length(element(data.null_data_source.ids.*.outputs.id, count.index)) ?
      join(var.delimiter,
        list(
          substr(element(data.null_data_source.org.*.outputs.id, count.index),0,
            element(data.null_data_source.ids-trunc.*.outputs.org_attr_32, count.index) >= 0 ?
              element(data.null_data_source.ids-trunc.*.outputs.org_attr_32, count.index) : 0)
        ),
        list(local.attr)
      )
      : element(data.null_data_source.ids.*.outputs.id, count.index)}"
  }
}

# 2 lists keys and values
# TODO: need to change to list of maps for all label names
data "null_data_source" "tags" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  inputs = {
    #TODO: only add Organization if not ""
    tag_keys = "Name,Environment,Organization,Terraform"
    tag_vals = "${join(",",list(
      element(data.null_data_source.ids.*.outputs.id, count.index),
      local.env,
      local.org,
      "true")
      )}"
  }
}
/*
data "null_data_source" "tag_list" {
  count = "${module.enabled.value ? length(var.names) : 0}"
  inputs = {
    tags = "${}"
  }
}
/*
output "tags" {
  description = "Tags map merged with standard tags"
  value       = "${merge(
    zipmap(split(",",data.null_data_source.tags.*.outputs.tag_keys[0]),
      split(",",data.null_data_source.tags.*.outputs.tag_vals[0])),
    var.tags)}"
}
/**/
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
