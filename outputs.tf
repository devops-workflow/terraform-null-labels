
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
  value       = "${compact(concat(null_resource.ids.*.triggers.id, list("")))}"
}
output "id_20" {
  description = "ID truncated to 20 characters"
  value       = "${compact(concat(null_resource.ids-trunc.*.triggers.id_20, list("")))}"
}
output "id_32" {
  description = "ID truncated to 32 characters"
  value       = "${compact(concat(null_resource.ids-trunc.*.triggers.id_32, list("")))}"
}
output "id_attr_20" {
  description = "ID max size 20 characters by truncating `id_org` then appending `attributes`"
  value       = "${compact(concat(null_resource.ids-trunc-attr.*.triggers.id_attr_20, list("")))}"
}
output "id_attr_32" {
  description = "ID max size 32 characters by truncating `id_org` then appending `attributes`"
  value       = "${compact(concat(null_resource.ids-trunc-attr.*.triggers.id_attr_32, list("")))}"
}
output "id_env" {
  description = "If env namespace enabled <env>-<name> else <name>"
  value       = "${compact(concat(null_resource.env.*.triggers.id, list("")))}"
}
output "id_org" {
  description = "If org namespace enabled <org>-<id_env> else <id_env>"
  value       = "${compact(concat(null_resource.org.*.triggers.id, list("")))}"
}
output "name" {
  description = "Name lowercase"
  value       = "${compact(concat(null_resource.names.*.triggers.id, list("")))}"
}
output "organization" {
  description = "Organization name lowercase"
  value       = "${local.org}"
}
/*
output "tags" {
  description = "Tags map merged with standard tags"
  value       = "${compact(concat(null_resource.tags.*.triggers.tag, list("")))}"
}
*/
//debugging
output "org_attr_20" {
  description = "Internal debugging. DO NOT USE"
  value       = "${compact(concat(null_resource.ids-trunc.*.triggers.org_attr_20, list("")))}"
}
output "org_attr_32" {
  description = "Internal debugging. DO NOT USE"
  value       = "${compact(concat(null_resource.ids-trunc.*.triggers.org_attr_32, list("")))}"
}
