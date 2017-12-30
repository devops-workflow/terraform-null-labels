# terraform-null-labels

Terraform module to provide consistent label names and tags for resources.

This is similar to [label](https://registry.terraform.io/modules/devops-workflow/label/local) except:
- This accepts a list of names, instead of a string. And returns lists.
- This uses null-resource instead of locals. This was required to be able to use count.
- Currently this does not return tags

The goal is to keep [label](https://registry.terraform.io/modules/devops-workflow/label/local) and [labels](https://registry.terraform.io/modules/devops-workflow/labels/null) in sync and update both at the same time for any changes. Where this is possible.

A single name format will not solve every use case, so multiple variants are returned and there is a few options to affect how they get build. The general name convention is `{organization}-{environment}-{name}-{attributes}`. `Name` is required, the other 3 can be turned on/off individually. The delimiter (`-`) can be changed

All [devops-workflow](https://registry.terraform.io/modules/devops-workflow) modules will eventually use this or [label](https://registry.terraform.io/modules/devops-workflow/label/local).

**NOTE:** `null` refers to this using [null_resource](https://www.terraform.io/docs/configuration/locals.html)

Terraform registry: https://registry.terraform.io/modules/devops-workflow/labels/null

# TODO: update rest of readme

## Usage:

#### Basic Example

```hcl
module "name" {
  source        = "devops-workflow/label/local"
  version       = "0.1.2"
  name          = "name"
  environment   = "qa"
}
```
This will create an `id` with the value of `qa-name`

#### S3 Example

```hcl
module "s3-name" {
  source        = "devops-workflow/label/local"
  version       = "0.1.2"
  name          = "data"
  environment   = "qa"
  organization  = "corp"
  namespace-org = "true"
}
```
This will create an `id` with the value of `corp-qa-data`

Now reference `label` outputs to create the S3 bucket

```hcl
resource "aws_s3_bucket" "data" {
  bucket  = "${module.s3-name.id}"
  tags    = "${module.s3-name.tags}"
}
```

#### All Variables Example
Using in a module and exposing all settings to upstream caller.

```hcl
module "label" {
  source        = "devops-workflow/label/local"
  version       = "0.1.2"
  organization  = "${var.organization}"
  name          = "${var.name}"
  namespace-env = "${var.namespace-env}"
  namespace-org = "${var.namespace-org}"
  environment   = "${var.environment}"
  delimiter     = "${var.delimiter}"
  attributes    = "${var.attributes}"
  tags          = "${var.tags}"
}
```
