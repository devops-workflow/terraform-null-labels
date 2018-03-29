output "attributes" {
  description = "Attribute string lowercase"
  value       = "${local.attr}"
}

output "environment" {
  description = "Environment name lowercase"
  value       = "${local.env}"
}

output "id" {
  description = "Fully formatted name ID"
  value       = "${compact(concat(data.null_data_source.ids.*.outputs.id, list("")))}"
}

output "id_20" {
  description = "ID truncated to 20 characters"
  value       = "${compact(concat(data.null_data_source.ids-trunc.*.outputs.id_20, list("")))}"
}

output "id_32" {
  description = "ID truncated to 32 characters"
  value       = "${compact(concat(data.null_data_source.ids-trunc.*.outputs.id_32, list("")))}"
}

output "id_attr_20" {
  description = "ID max size 20 characters by truncating `id_org` then appending `attributes`"
  value       = "${compact(concat(data.null_data_source.ids-trunc-attr.*.outputs.id_attr_20, list("")))}"
}

output "id_attr_32" {
  description = "ID max size 32 characters by truncating `id_org` then appending `attributes`"
  value       = "${compact(concat(data.null_data_source.ids-trunc-attr.*.outputs.id_attr_32, list("")))}"
}

output "id_env" {
  description = "If env namespace enabled <env>-<name> else <name>"
  value       = "${compact(concat(data.null_data_source.env.*.outputs.id, list("")))}"
}

output "id_org" {
  description = "If org namespace enabled <org>-<id_env> else <id_env>"
  value       = "${compact(concat(data.null_data_source.org.*.outputs.id, list("")))}"
}

output "name" {
  description = "Name lowercase"
  value       = "${compact(concat(data.null_data_source.names.*.outputs.id, list("")))}"
}

output "organization" {
  description = "Organization name lowercase"
  value       = "${local.org}"
}

# TODO: need to change to list of maps for all label names
output "tags" {
  description = "Tags map merged with standard tags"

  value = "${merge(
    zipmap(
      split(",", element(concat(data.null_data_source.tags.*.outputs.tag_keys, list("")),0)),
      split(",", element(concat(data.null_data_source.tags.*.outputs.tag_vals, list("")),0))),
    var.tags)}"
}

//debugging
output "org_attr_20" {
  description = "Internal debugging. DO NOT USE"
  value       = "${compact(concat(data.null_data_source.ids-trunc.*.outputs.org_attr_20, list("")))}"
}

output "org_attr_32" {
  description = "Internal debugging. DO NOT USE"
  value       = "${compact(concat(data.null_data_source.ids-trunc.*.outputs.org_attr_32, list("")))}"
}
